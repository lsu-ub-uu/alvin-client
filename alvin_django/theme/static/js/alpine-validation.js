const startingWith =
  (subject, replacement) =>
  ({ name, value }) => {
    if (name.startsWith(subject)) {
      name = name.replace(subject, replacement);
    }
    return { name, value };
  };

document.addEventListener("alpine:init", () => {
  Alpine.prefix("data-x");
  Alpine.mapAttributes(startingWith("data-xon.", Alpine.prefixed("on:")));
  Alpine.mapAttributes(
    startingWith("data-xbind.", Alpine.prefixed("bind:"))
  );
});