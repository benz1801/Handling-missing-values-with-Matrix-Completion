# Handling Missing Values with Matrix Completion

## Project Overview
This project tackles the issue of missing values in datasets using matrix completion techniques. The focus is on leveraging Principal Component Analysis (PCA) and a Hard-Impute algorithm to handle missing data efficiently. The project applies these methods to a dataset from **Clash Royale**, a popular mobile strategy game, which contains information on various cards used by players.

### Objectives:
- Handle missing values in datasets using matrix completion methods.
- Demonstrate how to use PCA to impute missing values.
- Apply the Hard-Impute algorithm for matrix completion.
- Evaluate the performance of the methods based on simulation results.

---

## Dataset: Clash Royale Cards
The dataset used in this project includes detailed information about 107 cards from the **Clash Royale** game. Each card has multiple attributes:

- **Card Name**: Name of the card.
- **Cost**: Mana cost to play the card.
- **Count**: Number of units spawned.
- **Damage**: Total damage dealt by the card.
- **Damage per Second (DPS)**: Damage dealt per second.
- **Death Damage**: Damage upon death (if applicable).
- **Hitpoints**: Health points of the card.
- **Hit Speed**: Time between attacks.
- **Range**: Distance from which the card can attack.
- **Type**: Whether it is a troop, building, or spell.
- **Rarity**: Common, rare, epic, or legendary.
- **Evolution**: Whether the card has an evolution mechanic.
- **Ability**: Special abilities, if any.
- **Win Rate %**: Win rate in battles.
- **Rating**: Overall rating of the card.
- **Usage %**: Usage rate among players.

Some attributes are excluded from the analysis as they may not contribute significantly to the analysis of missing values.

---

## Matrix Completion & PCA
The approach taken in this project addresses missing data by exploiting the correlation structure between variables. The **Matrix Completion** technique is used to impute missing values based on principal components. This allows us to estimate missing entries without simply using basic strategies like mean imputation.

### Why Matrix Completion?
- Removing rows with missing values is wasteful and often unrealistic.
- Basic mean imputation fails to consider the relationships between variables.
- Matrix completion provides a more informed approach by leveraging the relationships between observed variables to predict missing values.

---

## Hard-Impute Algorithm
The **Hard-Impute Algorithm** is used to impute missing values in a dataset, specifically when missingness is assumed to be random. The algorithm involves the following steps:

1. **Initial Matrix Imputation**: Create a complete matrix by filling in missing values with the column means.
2. **PCA-Based Imputation**: Iteratively compute the principal components of the observed data and update the missing values using these components.
3. **Convergence Check**: Repeat the process until the objective function no longer decreases, ensuring convergence.

### Hard-Impute Steps:
1. Start with the matrix \(\tilde{X}\), where missing values are replaced by the column mean.
2. Compute the principal components of \(\tilde{X}\) and update the missing values with their predicted values from the principal component scores.
3. Repeat until the process converges, i.e., the sum of squared errors stops decreasing.

---

## Simulation and Choice of Components
A simulation is used to determine the optimal number of principal components (denoted as \(M\)) for matrix completion. The project experiments with different values of \(M\), comparing the correlation between observed and imputed values across multiple iterations.

### Key Results:
- Using 2 principal components leads to a correlation of 0.376 with observed values.
- Increasing \(M\) to 9 components gives a lower correlation (0.373) and requires significantly more iterations (1164 vs. 18).
- A balance between accuracy and computational efficiency is achieved with fewer principal components (e.g., \(M = 2\)).

---

## Performance Evaluation
The performance of the matrix completion method is evaluated by comparing the mean sum of squares (MSS) between the observed and imputed values. Additionally, the **relative error** is computed to track the improvement over iterations.

### Performance Metrics:
- **Mean Sum of Squares (MSS)**: Measures the difference between observed and imputed values.
- **Relative Error (RE)**: Quantifies how much the MSS improves across iterations.

The best performance is achieved with \(M = 9\), yielding a correlation close to 1, indicating that the imputed values are almost identical to the true ones. However, a smaller number of components (e.g., \(M = 2\)) provides a faster convergence with reasonable accuracy.

---

## Conclusion
Matrix completion using PCA and the Hard-Impute algorithm is an effective approach for handling missing values in datasets. The method is particularly useful when the missingness is random, as in the case of the Clash Royale dataset. The trade-off between accuracy and computational cost is highlighted, with smaller models converging faster but larger models providing better imputation accuracy.

### References:
- Gareth James, Daniela Witten, Trevor Hastie, Robert Tibshirani, *An Introduction to Statistical Learning*, Second Edition, June 2023.

---

## How to Run the Project
1. **Dependencies**: The project requires the following R packages:
   ```r
   install.packages(c("ggplot2", "Matrix", "missMDA"))
