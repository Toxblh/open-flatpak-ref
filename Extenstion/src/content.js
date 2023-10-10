function changeFlatpakLinks(node) {
  node.querySelectorAll('a[href$=".flatpakref"]').forEach((oldLink) => {
    if (oldLink.href.startsWith("https://dl.flathub.org/repo/appstream")) {
      const newLink = document.createElement('a');
    
      newLink.href = oldLink.href.replace(/^https:/, 'flatpak:');
      newLink.textContent = oldLink.textContent;
      
      // copying class from old link
      newLink.className = oldLink.className;

      oldLink.parentNode.replaceChild(newLink, oldLink);
    }
  });
}

// Run the function initially
changeFlatpakLinks(document.body);

// Create a MutationObserver instance to watch for changes in the DOM
const observer = new MutationObserver((mutations) => {
mutations.forEach((mutation) => {
  if (mutation.type === 'childList' && mutation.addedNodes.length > 0) {
    mutation.addedNodes.forEach((node) => {
      if (node.nodeType === Node.ELEMENT_NODE) {
        // Apply function on added/modified elements only
        changeFlatpakLinks(node);
      }
    });
  }
});
});

// Start observing the document with the configured parameters
observer.observe(document.body, { childList: true, subtree: true });