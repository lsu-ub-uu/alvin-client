// Initialization for ES Users
import {
  Ripple,
  Input,
  Dropdown,
  initTWE,
} from "tw-elements";

const searchInputDropdown = document.getElementById('search-input-dropdown');
const dropdownOptions = document.querySelectorAll('#dropdown-search [data-twe-dropdown-item-ref]');

searchInputDropdown.addEventListener('input', () => {
  const filter = searchInputDropdown.value.toLowerCase();
  showOptions();
  const valueExist = !!filter.length;

  if (valueExist) {
    dropdownOptions.forEach((el) => {
      const elText = el.textContent.trim().toLowerCase();
      const isIncluded = elText.includes(filter);
      if (!isIncluded) {
        el.classList.add("hidden")
      }
    });
  }
});

const showOptions = () => {
  dropdownOptions.forEach((el) => {
    el.classList.remove("hidden")
  })
}