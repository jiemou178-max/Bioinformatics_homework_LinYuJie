# Week 4 Homework Report

**Name:**  林煜杰
**Student ID:**  SUAT24000170
**Date:**  2026.09.20
**Course:** Bioinformatics: From Multi-Omics Data to Discovery  

---

## Question 1 — Choose the Right Genomic Assay (25 pts)

### 1. Reasoning before AI

<!-- First assay choice and why; brief overall strategy -->

我想第一个选WGS策略，因为它能完整筛查基因X上下游调控区域的点突变、插入缺失、结构变异等，获得的信息最多也最完整，可以更快确定后续验证步骤大致的方向，减少工作量
我预设的验证流程如下：
1、使用WGS全面筛查基因组序列，寻找是否存在序列层面的调控突变
2、使用WGBS进行全基因组单碱基分辨率的甲基化检测，验证是否因甲基化降低导致基因X上调
3、使用ATAC-seq在全基因组范围精准绘制开放染色质图谱，验证是否因染色质开放性升高、可及性增加，导致基因X转录上调
4、使用CUT&Tag定位并验证是否因转录因子、组蛋白修饰导致基因X上调
5、使用Micro-C验证是否因空间互作增强导致基因X上调

### 2. AI-assisted workflow

<!-- Main prompt(s) or agent steps; how AI critiqued your design -->

我将题目与我的预设发送给AI，让它对我的方案进行点评，提示词（我是一名大学生，正在完成生物信息学课程的作业，现在给你上传了两张图片，包含一道题目以及对于其第一步我的回答，现在需要你帮助我完成这道题目的第二步：借助AI点评并优化我的方案。请注意输出的科学严谨性） 
AI输出中的摘要：你的整体思路是对的，而且方法覆盖范围已经比较完整。真正需要优化的不是“再增加更多实验”，而是把每个 assay 的证据层级和因果强度说准确，否则老师很容易抓到几个逻辑漏洞。
不过它后续也并不是只把每个 assay 的证据层级和因果强度说准确，还是有实验方面的补充与步骤的修改。
AI的回复非常长，并不便于全部粘贴，后续回复总结的修改步骤如下：

My initial design was reasonable in selecting WGS as the first assay, because WGS can identify both coding and non-coding genetic variation, including candidate cis-regulatory SNVs, indels, and structural variants around Gene X. However, after critically reviewing the design, I identified several issues.

First, WGS should not be limited to the “downstream regulatory region” of Gene X. Regulatory elements can occur upstream, downstream, within introns, or at distal intergenic enhancers. In addition, identifying a variant by WGS does not establish that the variant causes Gene X upregulation; it only provides a candidate genetic mechanism. WGS-based discovery of non-coding variants therefore needs subsequent functional validation.

Second, WGBS and ATAC-seq can detect epigenetic differences, but neither assay alone demonstrates causality. WGBS measures DNA methylation patterns at high genomic resolution, so it can determine whether the promoter or enhancer regions of Gene X are differentially methylated between disease and control samples. However, the correct conclusion would be that altered methylation is associated with Gene X upregulation, rather than that methylation directly causes the upregulation. Similarly, ATAC-seq measures genome-wide chromatin accessibility and can test whether the promoter or candidate enhancers of Gene X become more accessible in the disease group, but increased accessibility by itself remains a correlation.

Third, CUT&Tag should be target-specific rather than being described as a general assay for “transcription factors and histone modifications.” Candidate transcription factors can be selected based on sequence motifs, WGS variants, or accessibility changes, while specific histone marks such as H3K27ac, H3K4me3, or H3K27me3 can be examined according to the proposed regulatory mechanism. ENCODE guidelines emphasize the importance of defined targets and characterized antibodies for chromatin-associated assays.

Fourth, Micro-C is appropriate for testing altered enhancer–promoter contacts, but it should preferably be used after candidate regulatory elements have been prioritized. Genome-wide Micro-C is technically demanding and sequencing-intensive, whereas the biological question here is focused on the regulation of Gene X. Therefore, Micro-C should be used to test whether a specific candidate enhancer identified by WGS/ATAC-seq shows altered contact with the Gene X promoter. Micro-C can provide high-resolution information about fine-scale enhancer–promoter interactions, but contact changes alone do not establish causality.

The optimized strategy is therefore:

1. **WGS:** identify candidate cis-regulatory SNVs, indels, structural variants, or copy-number changes in the promoter and distal regulatory regions of Gene X.

2. **ATAC-seq:** compare chromatin accessibility between disease and control samples and determine whether candidate promoter/enhancer regions of Gene X become more accessible.

3. **WGBS/EM-seq:** determine whether the same regulatory regions show differential DNA methylation.

4. **CUT&Tag:** examine selected transcription factors and histone modifications at candidate regulatory elements to determine whether transcription-factor occupancy or active/repressive chromatin marks are altered.

5. **Micro-C:** test whether candidate distal regulatory elements show altered three-dimensional contact with the Gene X promoter.

6. **MPRA:** for candidate regulatory variants identified by WGS, directly compare the regulatory activity of alternative alleles. MPRA is useful for testing many candidate regulatory sequences or variants in parallel.

7. **CRISPR perturbation:** perturb the highest-priority regulatory element in its endogenous genomic context and measure the effect on Gene X expression. This provides stronger causal evidence than observational epigenomic assays alone.

Thus, the key improvement is to distinguish **discovery, mechanism identification, and causal validation**. WGS can identify a candidate genetic mechanism; ATAC-seq, WGBS/EM-seq, CUT&Tag, and Micro-C can determine which molecular features are altered; and MPRA plus CRISPR perturbation can test whether the candidate regulatory mechanism is functionally responsible for the increased expression of Gene X.

RNA-seq can be used as a baseline confirmation and as an expression readout after perturbation, but because the upregulation of Gene X is already established in the question, it is not the primary assay for identifying the upstream mechanism.



### 3. Verification

<!-- ≥2 authoritative sources; what you confirmed or revised -->

1、AI说WGS是用于寻找候选非编码调控变异，NHGRI 2024 年关于functional variant interpretation的报告明确讨论了non-coding variants，包括promoter等调控区域的变异，并强调需要进一步实验验证其功能。所以我采纳了这个建议，对原来的表述进行修改
2、NHGRI 那份报告还明确提到MPRA → CRISPR 可以用于非编码变异的功能验证，所以我也采纳了AI的建议，增加了最后的验证步骤
3、ATAC-seq的经典方法论文发表于 Nature Methods，明确指出ATAC-seq用于检测open chromatin，并可以在全基因组范围分析染色质可及性。所以我原来的表述可以保留，但也和它说的一样要注意因果性，也是需要稍做补充与修改

### 4. Final conclusion

**~200-word explanation** (what each assay measures, cannot prove, and how assays complement):

总之，比较合适的策略是结合基因组、表观基因组、染色质和功能实验，系统确定导致 Gene X 上调的具体机制
先使用WGS 寻找基因x启动子及远端调控区域中的候选调控变异，包括SNV、indel 和结构变异等。随后使用ATAC-seq检测这些区域的染色质可及性是否发生变化，同时使用WGBS/检测DNA甲基化差异。接着使用CUT&Tag分析候选转录因子结合以及相关的组蛋白修饰。如果发现候选远端增强子，则可进一步使用Micro-C检测其与基因X启动子的三维空间互作是否发生改变
这些实验可以帮助确定哪些调控机制与 Gene X 上调相关，但不能单独证明因果关系。因此，进一步使用MPRA检验候选调控变异是否直接改变调控活性，并通过CRISPR perturbation在内源基因组环境中验证候选调控元件是否真正影响基因X表达
完整流程可以概括为：
WGS → 表观遗传与染色质分析 → 三维基因组分析 → 功能及因果验证

**Figure:** `figures/Q1_workflow.png` (or .pdf / .svg)

markdown文件无法插入图片，见github仓库中同文件夹下Q1_workflow.png

> **The biological question chooses the assay because…**

---

## Question 2 — From FASTQ to a Trustworthy Analysis Workflow (25 pts)

### 1. Reasoning before AI

<!-- Your hand-drawn / self-designed workflow steps and purpose of each -->
我没安装FastQC，所以我去看了fastqc_snapshot.tsv
我初步想的工作流是：
FASTQ QC：用FastQC/MultiQC看质量、接头、GC、重复等，判断是否需要修剪
Trimming：用fastp或Trimmomatic去接头和低质量末端，然后再做一次 QC
参考基因组：选人类GRCh38，并统一注释和染色体命名。
比对：按assay选工具，比如DNA用BWA-MEM2，RNA-seq用STAR/HISAT2，ATAC/ChIP用Bowtie2/BWA
BAM 处理：排序、索引、去重、过滤 MAPQ 和黑名单区域
下游分析：RNA-seq做表达和差异分析；WGS/WES做变异calling；ATAC/ChIP做peak calling
注释、可视化和解读：把结果连到基因功能、通路和生物学假设
从snapshot看：adapter content是FAIL，per-base quality、GC content、duplication是WARN，overrepresented sequences也是 FAIL；N content和read length是PASS。这说明最优先的是去接头和末端质量修剪，然后重新QC
不过，参考基因组具体版本、比对工具参数、下游分析分支我还没有定，这些需要下一步让 AI 帮我检查，再查官方文档确认

### 2. AI-assisted workflow

<!-- Plan-first prompt; key commands/tools AI suggested -->
我用的是 plan-first 的思路，先让AI检查我的工作流，而不是直接让它替我决定工具和参数。提示词大概为（我是一名学生，正在完成生物信息学的作业，给你上传了题目的截图和我第一步的回答，需要你完成第二步：用AI检查与提出优化建议。请你帮我检查：每个步骤的目的是否清楚；我缺少哪些 QC 检查点；RNA-seq、WGS/WES、ATAC-seq、ChIP-seq/CUT&Tag 分别应该在哪一步分叉；哪些参数必须查官方文档确认而不能直接采取建议。）
AI 主要给了这些建议：
加MultiQC汇总QC，并在trimming后再做一次 FastQC，确认接头和低质量末端被处理掉
参考基因组用人类 GRCh38，但要注意 Ensembl、UCSC、GENCODE 的染色体命名和注释版本要统一
比对工具按assay分：DNA用BWA-MEM2，RNA-seq用STAR或HISAT2，ATAC/ChIP 用Bowtie2或BWA
BAM处理要包括排序、索引、去重、MAPQ过滤，ATAC/ChIP还要考虑黑名单区域
下游分析要分叉：RNA-seq 做表达和差异分析，WGS/WES 做变异 calling，ATAC/ChIP 做 peak calling
注释和可视化可以用VEP/ANNOVAR、ChIPseeker、IGV、UCSC、ggplot2等
我的选择是：我接受这个整体框架，做出补充与修改，但参考基因组版本、比对参数、过滤阈值和下游工具参数需要下一步查官方文档再决定


### 3. Verification

<!-- Docs checked for genome build, formats, software, parameters -->
我主要查了这些官方文档或常用来源，确认工具用途和基本流程：
FastQC/MultiQC：确认 QC 指标含义和报告方式
fastp/Trimmomatic：确认接头去除和质量修剪的用途
BWA-MEM2、STAR、HISAT2、Bowtie2：确认不同assay的比对工具选择
GATK、Picard、samtools：确认BAM处理、去重和变异calling的基本步骤
Ensembl/UCSC/GENCODE：确认GRCh38和注释版本
MACS3、ChIPseeker：确认ATAC/ChIP的peak calling和注释

**FastQC metrics (≥4):**

| Metric                      | What I looked for                      | Interpretation                    |
| --------------------------- | -------------------------------------- | --------------------------------- |
| Adapter content             | FAIL；`AGATCGGAAGAGC` 在3′端升高，约15% pairs | 需要去接头，然后重新QC                      |
| Per base sequence quality   | WARN；R1约15%在cycle 50后Phred降到~12        | 需要 3′ 端质量修剪                       |
| Per sequence GC content     | WARN；主峰~41% GC，还有~78% 高GC肩峰            | 可能有高GC污染，需要检查                     |
| Sequence duplication levels | WARN；一个模板序列在R1中重复约15%                  | 可能是 PCR/重复陷阱；WGS要 mark duplicates |

**AI-audit table:**

| AI recommendation     | My verification                 | Final decision                  |
| --------------------- | ------------------------------- | ------------------------------- |
| 使用 GRCh38             | 查 Ensembl/UCSC/GENCODE，确认人类常用参考 | 查 Ensembl/UCSC/GENCODE，确认人类常用参考 |
| DNA用BWA-MEM2，RNA用STAR | DNA用BWA-MEM2，RNA用 STAR          | 作为DNA 分支，RNA不直接用                |
| ATAC/ChIP用MACS3       | 查MACS3文档，确认需要input control      | 保留，但FDR和参数要自己定                  |

### 4. Final conclusion

**Figure:** `figures/Q2_workflow.png`

markdown文件无法插入图片，见github仓库中同文件夹下Q2_workflow.png

> **The analyst, not the AI, is responsible for…

---

## Question 3 — Multi-Omics Regulatory Hypothesis (25 pts)

### 1. Reasoning before AI

<!-- Independent layer reads + preliminary integrated model -->
我看了这五层数据：
ATAC-seq：候选区域有开放 peak，说明这里染色质是可及的，可能有调控功能
H3K27ac：这个区域有 H3K27ac 信号，它有可能是一个活跃增强子
DNA methylation：这个区域甲基化比较低，低甲基化通常和活跃调控有关，所以它应该是有功能的
Hi-C / Micro-C：候选区域和 Gene Y 启动子有 3D 接触，所以我认为它有机会调控 Gene Y
RNA-seq：Gene Y 有表达，说明这个调控关系是可能存在的
把这些放在一起，我的初步想法是：
这个上游区域很大可能就是 Gene Y 的增强子，它通过开放染色质、H3K27ac 和 3D 接触来调控 Gene Y 的表达

### 2. AI-assisted workflow

<!-- Prompt asking AI to separate observations / interpretations / missing evidence -->
我用的是 plan-first 的思路，先让 AI 检查我的证据整合。提示词大概是---我是一名学生，正在完成生物信息学的作业，给你上传了题目的截图和我第一步的回答，需要你完成第二步：用AI检查与提出优化建议。请你帮我：把证据分成直接观察、生物学解释、缺失证据；指出我哪里可能有逻辑问题；提出至少一个替代解释设计一个能区分相关和因果的功能实验。注意不要替我决定最终结论。

AI 主要给了这些建议：
直接观察：候选区域有开放 peak、H3K27ac 信号、低甲基化、与 Gene Y 启动子有 3D 接触、Gene Y 有表达
生物学解释：这些证据支持它可能是活跃增强子，但不能证明它一定调控 Gene Y
缺失证据：TF motif、eRNA、等位基因特异信号、扰动实验、时间顺序、细胞类型纯度、重复
我的问题：把 H3K27ac 当成增强子的充分证据，把 Hi-C 接触当成功能调控，把低甲基化当成因果
替代解释：它可能是启动子、绝缘子、其他基因的增强子，或者 3D 接触没有功能
功能实验：CRISPRi 靶向候选区域，看 Gene Y 表达是否下降；也可以用增强子删除或 MPRA

### 3. Verification

<!-- How you checked AI framing; sources consulted -->
我主要查了 ENCODE、Roadmap Epigenomics、4D Nucleome，以及 CRISPRi/CRISPRa和MPRA的综述。简单确认了几点：
ATAC-seq 开放不等于增强子
H3K27ac 支持活跃染色质，但不能单独证明靶基因
低甲基化与活跃调控相关，但不能证明因果
Hi-C/Micro-C 接触不等于功能调控
CRISPRi 或增强子删除可以测试因果，但需要对照

### 4. Final conclusion

**Observations vs interpretations vs missing evidence:**

| Layer          | Direct observation | Interpretation | Missing evidence |
| -------------- | ------------------ | -------------- | ---------------- |
| ATAC-seq       | 候选区域有开放 peak       | 可能有调控活性        | 不能证明是增强子         |
| H3K27ac        | 有 H3K27ac 信号       | 可能是活跃增强子/启动子   | 不能证明靶基因          |
| Methylation    | 低甲基化               | 与活跃调控一致        | 因果关系不明           |
| Hi-C / Micro-C | 与 Gene Y 启动子有接触    | 可能有物理连接        | 接触不等于功能调控        |
| RNA-seq        | Gene Y 有表达         | 提供转录读出         | 不能说明由该区域调控       |

**Alternative explanation:**

这个区域也可能不是 Gene Y 的增强子，而是 Gene Y 的启动子、其他基因的增强子、绝缘子，或者 Hi-C 接触只是细胞群平均的结构噪音

**Functional experiment (correlation vs causality):**

用 CRISPRi（dCas9-KRAB）靶向候选区域，抑制其调控活性，然后用 qPCR 或 RNA-seq 检测 Gene Y 表达是否下降。对照包括非靶向 gRNA 和邻近非调控区域。如果 Gene Y 表达显著下降，就支持该区域是 Gene Y 的增强子；如果不变，则说明它可能不是主要调控元件

**~200-word integrated interpretation:**

综合五层数据，候选区域有开放染色质、H3K27ac 信号、低甲基化、与 Gene Y 启动子的 3D 接触，同时 Gene Y 有表达。这些证据放在一起，支持该区域可能是 Gene Y 的活跃增强子。但需要注意，这些大多是相关性证据：ATAC 开放和 H3K27ac 不能单独证明增强子身份，低甲基化可能是结果而不是原因，Hi-C 接触也不等于功能调控。因此目前只能说它“可能”是增强子，不能直接下因果结论。替代解释包括它是启动子、其他基因的增强子或绝缘子。为了区分相关与因果，最直接的功能实验是用 CRISPRi 抑制该区域，然后检测 Gene Y 表达是否下降。如果下降且对照正常，就支持它是增强子；如果不变，则可能是其他机制。这样就能从多组学相关证据走向因果验证

**Figure:** `figures/Q3_locus_chain.png`  
Chain: Accessibility → chromatin state → methylation → 3D contact → expression → perturbation

> **The candidate element regulates Gene Y by ______, and this can be tested by ______.**

---

## Question 4 — Variant Prioritization (25 pts)

### 1. Reasoning before AI

<!-- Your filtering logic: quality, AF, consequence, clinical/biological evidence -->
我先看了 variants_q4.tsv。我的初步过滤逻辑是：
技术质量：先看 FILTER、DP、GQ，排除 FAIL 和明显低质量的位点
群体频率：AF 越低越可疑，常见变异先放后面
功能后果：优先 HIGH/MODERATE，比如 splice_acceptor、stop_gained、frameshift、missense
临床证据：优先 ClinVar Pathogenic，其次 uncertain/conflicting，Benign 先排除
按这个逻辑，我第一眼会关注：
chr17 TP53 splice_acceptor：Pathogenic，DP=80，GQ=99，AF=0.00001，看起来最像
chr2 MSH2 stop_gained：Pathogenic，但 LowQual，DP=8，GQ=12
chrX MECP2 frameshift：Pathogenic，但 DP=5，GQ=20
chr12 KRAS missense：Conflicting，AF=0.00015
我现在的初步想法是：TP53 这个最值得看；MSH2 虽然 LowQual，但 ClinVar 是 Pathogenic，而且 stop_gained 很严重，所以可能也要考虑；MECP2 是 frameshift，也可能重要；KRAS 有 conflicting，先不确定

### 2. AI-assisted workflow

<!-- Plan-first prompt; filtering code/workflow used -->
我让 AI 检查我的过滤逻辑。提示词大概是---我是一名学生，正在完成生物信息学的作业，给你上传了题目的截图和我第一步的回答，需要你完成第二步：用AI检查与提出优化建议。请你帮我检查这些阈值是否合理；ClinVar Pathogenic 能不能直接当成最终证据；LowQual 但 ClinVar Pathogenic 的变异怎么处理；chrX 上的 MECP2 frameshift 和 KRAS conflicting 有什么特殊注意点。注意不要直接给我最终变异，只指出逻辑漏洞、缺失证据和需要查证的地方
AI 主要给了这些建议：
DP、GQ、AF 阈值不能一刀切，要看测序类型和深度；DP=5 或 GQ=12 的位点可靠性很低。
ClinVar Pathogenic 只是一个数据库分类，不能替代质控；LowQual + Pathogenic 可能是假阳性，需要看原始 reads 或 Sanger 验证
stop_gained / frameshift 虽然后果严重，但不一定致病，可能在最后外显子、非关键区域，或者被无义介导降解影响
AF 很低只能说明罕见，不能直接证明致病；常见变异也可能有临床意义
chrX 上的 MECP2 要注意性别和剂量；男性半合子、女性随机失活都会影响判断
KRAS 是癌基因，conflicting 可能来自体细胞/胚系混用或不同疾病背景
应该查 gnomAD、ClinVar、ClinGen、Ensembl VEP、PubMed，而不是只看表格里的 CLINVAR_SIG

### 3. Verification

<!-- ≥2 resources (ClinVar, Ensembl, gnomAD-style AF sources, PubMed, etc.) -->
我主要查了 ClinVar、gnomAD、Ensembl VEP、ClinGen 和 PubMed，确认了几个基本点：
ClinVar：确认 TP53 splice_acceptor 的分类和提交记录；确认 KRAS 是 conflicting，不能直接当致病
gnomAD：确认 AF 是否真的罕见；TP53、MSH2、MECP2 的 AF 都很低，但 KRAS 和 F5 的 AF 偏高
Ensembl VEP / RefSeq：确认 splice_acceptor、stop_gained、frameshift 的注释位置和转录本影响
ClinGen / PubMed：确认 TP53、MSH2、MECP2 与疾病的基因-疾病关联是否明确

### 4. Final conclusion

**Top 1–2 variants and why:**

我最终选 **chr17:7673803 G>A（TP53 splice_acceptor_variant）** 作为首选。理由：FILTER=PASS，DP=80，GQ=99，AF=0.00001，ClinVar 为 Pathogenic，且位于 canonical splice junction 附近，功能后果严重

备选是 **chr2:47641560 A>G（MSH2 stop_gained）**，ClinVar 也是 Pathogenic，但 FILTER=LowQual，DP=8，GQ=12，技术质量太低，所以只列为“需验证”，不作为最终 top

**False-lead critique (and which concerns matter):**

我问 AI：TP53 这个变异最可能因为什么变成假线索？AI 提到：splice_acceptor 注释可能依赖转录本；DP/GQ 高仍可能是比对错误；ClinVar 分类可能过时或基于不同疾病背景；AF 极低也可能是测序错误；TP53 的致病性取决于具体疾病和遗传模式。

我认为最重要的是：**转录本和剪接注释是否准确**，以及 **该变异是否与患者表型匹配**。DP 和 GQ 都很高，所以技术假阳性可能性较低；但剪接影响需要实验验证，不能只靠数据库分类

**~200-word interpretation** structured as:

Known evidence → computational inference → scientific hypothesis → required experiment

已知证据：TP53 的 splice_acceptor 变异在 ClinVar 中为 Pathogenic，且位于 canonical splice junction 附近；该位点 FILTER=PASS，DP=80，GQ=99，AF=0.00001，属于罕见高置信位点。  
计算推断：它满足所有质量过滤，功能后果为 splice_acceptor，可能破坏正常剪接，导致 TP53 功能丧失。  
科学假设：该变异可能通过影响 TP53 剪接，导致蛋白功能异常，从而增加疾病风险。  
所需实验：先用 Sanger 验证该位点，再用 RT-PCR 或 minigene 剪接实验检测是否产生异常转录本；如果有家系样本，可做共分离分析；最后用功能实验（如细胞增殖、凋亡或 DNA 损伤反应）验证 TP53 功能是否受损。  
同时要查 gnomAD、ClinGen 和 PubMed，确认 AF、基因-疾病关联和临床背景。只有把数据库证据、计算推断和功能实验连起来，才能从“可能致病”走到“因果明确”。

**Figure:** `figures/Q4_prioritization.png`

> **Variant chr17:7673803 G>A may influence TP53 function by affecting a canonical splice acceptor site; this can be tested by RT-PCR/minigene splicing assays and functional studies**

---

## Appendix (optional)

- Prompts used (abbreviated)  
- Code snippets / filter thresholds  
- Extra figures
