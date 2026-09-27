
library(rstudioapi) 
setwd(dirname(getActiveDocumentContext()$path))
# 手动提取属名、聚合、去除全零、计算相对丰度

# 1. 读取原始数据
dat <- read.csv("16S_level-7.csv", row.names = 1, check.names = FALSE, stringsAsFactors = FALSE)

# 2. 只保留有明确属名 (g__) 的行
valid_rows <- grepl("g__[^;]+", rownames(dat))
dat <- dat[valid_rows, ]

# 3. 提取干净的属名
genus_names <- sapply(strsplit(rownames(dat), ";"), function(x) {
  g_idx <- grep("^g__", x)
  if(length(g_idx) > 0) sub("^g__", "", x[g_idx]) else NA
})

# 4. 按属名聚合（同一个属的多行相加）
dat_agg <- rowsum(dat, group = genus_names)

# 5. 去除在所有样本中都是 0 的属
dat_agg <- dat_agg[rowSums(dat_agg) > 0, ]

# 6. 手动计算相对丰度（每个样本的总和变成 100%）
# 这一步直接替代了工具的 Normalize 功能
dat_rel <- sweep(dat_agg, 2, colSums(dat_agg), "/") * 100

# 7. 保存为极其干净的 CSV 文件（第一列是纯属名，没有分号）
write.csv(dat_rel, "16S_genus_relative.csv", quote = FALSE, row.names = TRUE)

cat("清洗完成！共保留了", nrow(dat_rel), "个属。\n")
cat("已生成文件：16S_genus_relative.csv\n")
