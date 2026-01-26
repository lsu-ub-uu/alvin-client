function togglePanel(panelId) {
  const panel = document.getElementById(panelId);
  const header = panel.previousElementSibling; // Assuming header is the previous sibling

  if (panel.classList.contains('max-h-0')) {
    panel.classList.remove('max-h-0');
    // You might need to set an initial max-height or use a different approach for height transitions
    // For a better transition, you'd typically toggle a class that sets a specific max-height.
    // For example, if the content is short, you might do:
    // panel.classList.add('max-h-96'); // Replace 96 with an appropriate value or use a calculated value
  } else {
    panel.classList.add('max-h-0');
  }
}