#!/usr/bin/env Rscript

# Example R plot demonstrating the \rplotfile macro
# This script creates a simple bar chart with ggplot2

library(ggplot2)

# Sample data
data <- data.frame(
  category = c("Category A", "Category B", "Category C", "Category D"),
  value = c(23, 45, 32, 56)
)

# Create a clean bar chart
p <- ggplot(data, aes(x = category, y = value, fill = category)) +
  geom_col(color = "black", size = 0.5) +
  geom_text(aes(label = value), vjust = -0.5, size = 5, fontface = "bold") +
  
  # Styling
  scale_fill_manual(values = c("#64B464", "#6464B4", "#B46464", "#B4B464")) +
  scale_y_continuous(expand = c(0, 0), limits = c(0, 65)) +
  
  # Labels and theme
  labs(
    title = "Example Bar Chart",
    subtitle = "Generated automatically by R",
    x = NULL,
    y = "Value"
  ) +
  theme_minimal(base_size = 14) +
  theme(
    legend.position = "none",
    panel.grid.major.x = element_blank(),
    panel.grid.minor = element_blank(),
    plot.title = element_text(face = "bold", size = 16),
    plot.subtitle = element_text(color = "gray40"),
    axis.text.x = element_text(size = 12),
    axis.text.y = element_text(size = 11),
    plot.margin = margin(10, 10, 10, 10)
  )

# Save the plot as PDF
ggsave("example-plot.pdf", p, width = 8, height = 5, units = "in")

cat("Example plot saved to example-plot.pdf\n")
