# ================================================================
# Week 5 Homework Starter
# Bulk RNA-seq differential expression with DESeq2
# ================================================================

# Required packages:
# BiocManager::install(c("DESeq2", "apeglm"))
# install.packages(c("tidyverse", "pheatmap", "ggrepel"))
library(rstudioapi) 
# Set working directory
setwd(dirname(getActiveDocumentContext()$path))
#################Load Necessary tools##########################

suppressPackageStartupMessages({
  library(DESeq2)
  library(apeglm)
  library(tidyverse)
  library(ggrepel)
})

# ----------------------------
# 1. Project paths
# ----------------------------
count_file <- "Week5_Homework_Count_Matrix.csv"
metadata_file <- "Week5_Homework_Sample_Metadata.csv"

dir.create("outputs", showWarnings = FALSE)
dir.create("figures", showWarnings = FALSE)

# ----------------------------
# 2. Import
# ----------------------------
counts <- read.csv(
  count_file,
  row.names = 1,
  check.names = FALSE
)

coldata <- read.csv(
  metadata_file,
  row.names = 1,
  check.names = FALSE
)

# ----------------------------
# 3. Mandatory validation
# ----------------------------
stopifnot(ncol(counts) == nrow(coldata))
stopifnot(identical(colnames(counts), rownames(coldata)))
stopifnot(all(counts >= 0))
stopifnot(all(as.matrix(counts) == round(as.matrix(counts))))

coldata$condition <- relevel(factor(coldata$condition), ref = "control")
coldata$batch <- factor(coldata$batch)

print(table(coldata$batch, coldata$condition))
print(summary(colSums(counts)))

# ----------------------------
# 4. Construct DESeq2 object
# ----------------------------
dds <- DESeqDataSetFromMatrix(
  countData = counts,
  colData = coldata,
  design = ~ batch + condition
)

# TODO: Explain why batch is included in the design.

# ----------------------------
# 5. Pre-filter
# ----------------------------
keep <- rowSums(counts(dds) >= 10) >= 3
cat("Genes before filtering:", nrow(dds), "\n")
dds <- dds[keep, ]
cat("Genes after filtering:", nrow(dds), "\n")

# ----------------------------
# 6. Fit model
# ----------------------------
dds <- DESeq(dds)

coef_names <- resultsNames(dds)
print(coef_names)

# TODO: Confirm the exact treated-versus-control coefficient name.
# 运行时没有报错，系数名称正确
target_coef <- "condition_treated_vs_control"

if (!target_coef %in% coef_names) {
  stop(
    "Expected coefficient was not found. Inspect resultsNames(dds) and update target_coef."
  )
}

# ----------------------------
# 7. Extract and shrink results
# ----------------------------
res <- results(
  dds,
  contrast = c("condition", "treated", "control"),
  alpha = 0.05
)

res_shrunk <- lfcShrink(
  dds,
  coef = target_coef,
  type = "apeglm"
)

res_df <- as.data.frame(res_shrunk) |>
  rownames_to_column("gene_id") |>
  mutate(
    significant = !is.na(padj) &
      padj < 0.05 &
      abs(log2FoldChange) >= 1,
    direction = case_when(
      significant & log2FoldChange > 0 ~ "Up in treated",
      significant & log2FoldChange < 0 ~ "Down in treated",
      TRUE ~ "Not significant"
    )
  ) |>
  arrange(padj)

write.csv(
  res_df,
  "outputs/week5_deseq2_results.csv",
  row.names = FALSE
)

cat("Significant genes:", sum(res_df$significant), "\n")
print(table(res_df$direction))

# ----------------------------
# 8. PCA
# ----------------------------
vsd <- varianceStabilizingTransformation(dds, blind = FALSE)

pca_df <- plotPCA(
  vsd,
  intgroup = c("condition", "batch"),
  returnData = TRUE
)

percent_var <- round(100 * attr(pca_df, "percentVar"))

p_pca <- ggplot(
  pca_df,
  aes(
    x = PC1,
    y = PC2,
    color = condition,
    shape = batch,
    label = name
  )
) +
  geom_point(size = 4) +
  geom_text_repel(size = 3, max.overlaps = Inf) +
  labs(
    title = "Week 5 RNA-seq PCA",
    x = paste0("PC1: ", percent_var[1], "% variance"),
    y = paste0("PC2: ", percent_var[2], "% variance")
  ) +
  theme_bw(base_size = 12)

ggsave(
  "figures/week5_pca.png",
  p_pca,
  width = 7,
  height = 5,
  dpi = 300
)

# ----------------------------
# 9. Volcano plot
# ----------------------------
plot_df <- res_df |>
  mutate(
    neg_log10_padj = -log10(pmax(padj, 1e-300))
  )

p_volcano <- ggplot(
  plot_df,
  aes(
    x = log2FoldChange,
    y = neg_log10_padj,
    color = direction
  )
) +
  geom_point(alpha = 0.7, size = 1.8) +
  geom_vline(
    xintercept = c(-1, 1),
    linetype = "dashed"
  ) +
  geom_hline(
    yintercept = -log10(0.05),
    linetype = "dashed"
  ) +
  scale_color_manual(
    values = c(
      "Up in treated" = "#C0392B",
      "Down in treated" = "#2F6DB3",
      "Not significant" = "grey70"
    )
  ) +
  labs(
    title = "Differential expression: treated versus control",
    x = "Shrunken log2 fold change",
    y = "-log10 adjusted p value",
    color = NULL
  ) +
  theme_bw(base_size = 12)

ggsave(
  "figures/week5_de_plot.png",
  p_volcano,
  width = 7,
  height = 5,
  dpi = 300
)

# ----------------------------
# 10. Save reproducibility files
# ----------------------------
saveRDS(
  dds,
  "outputs/week5_deseq2_object.rds"
)

capture.output(
  sessionInfo(),
  file = "outputs/session_info.txt"
)

# ----------------------------
# 11. Student interpretation
# ----------------------------
# TODO: Write 100–150 words describing:
# - comparison and design
# - strongest QC observation
# - significant-gene count and direction
# - one biological interpretation
# - one limitation
# - how AI was used and independently verified

# 本研究比较了处理组treated与对照组control在转录组层面的差异表达。为了控制实验误差，我们在设计模型中纳入了batch（批次 A/B/C）作为协变量，从而在消除批次效应后，准确评估处理效应
# PCA 图显示，PC1解释24%方差，将样本按condition清晰地分为左右两群，而PC2解释9%方差，主要反映了批次差异。所有样本均在95%置信椭圆内，没有极端离群样本，说明数据质量良好，处理效应是变异的主要来源
# 在padj < 0.05且abs(log2FoldChange) >= 1的阈值下，共鉴定出60个显著差异表达基因。其中，在treated组中上调的基因有36个，下调的基因有24个
# 由于我没找到数据集中基因的具体名称，再根据最后的结果，我能做出的生物学解释就是在这次特定的处理下有60个基因的表达出现明显差异，所以细胞确实对这次的处理产生了显著的应激反应，也就是处理组确实发生了显著的转录组学改变
# 本研究的样本量较小，仅有12个样本，统计效能有限；且PC1仅解释了24%的变异，表明数据中仍存在未被模型捕获的其他变异来源。此外，转录组水平的变化不能完全代表蛋白质功能。最后，数据中的基因没有具体名称，无法进行生物机制方面的分析
# AI的使用主要在于：我借助AI大致理解了这份代码，借助AI查找将batch列入考虑的意义，借助AI解决原第八段代码使用vst()函数报错的问题，借助AI明确如何分析PCA图完成最强QC观察。我根据AI附上的信息来源，查询了DESeq2官方文档与官方制作的网站Bioconductor Newsletter以确定AI回答的准确性，发现回答中没有什么漏洞
