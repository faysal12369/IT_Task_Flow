<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Editable Select Dropdown</title>
  <style>
    .editable-dropdown {
      position: relative;
      display: inline-block;
    }
    .editable-select {
      padding: 8px;
      border: 1px solid #ccc;
      display: inline-block;
      cursor: pointer;
      min-width: 150px;
    }
    .dropdown-content {
      display: none;
      position: absolute;
      background-color: #f9f9f9;
      min-width: 150px;
      box-shadow: 0px 8px 16px rgba(0, 0, 0, 0.2);
      z-index: 1;
      border: 1px solid #ddd;
    }
    .dropdown-content div {
      padding: 8px;
      cursor: pointer;
      border-bottom: 1px solid #ddd;
    }
    .dropdown-content div:hover {
      background-color: #ddd;
    }
    .editable-dropdown:hover .dropdown-content {
      display: block;
    }
    .editable {
      padding: 5px;
      border: 1px solid #ccc;
      display: inline-block;
      min-width: 140px;
    }
  </style>
</head>
<body>

<div class="editable-dropdown">
  <div class="editable-select" id="selectedOption" contenteditable="true">Click to edit or select an option</div>
  <div class="dropdown-content" id="dropdownOptions">
    <div contenteditable="true" class="dropdown-item" data-value="Option 1">Option 1</div>
    <div contenteditable="true" class="dropdown-item" data-value="Option 2">Option 2</div>
    <div contenteditable="true" class="dropdown-item" data-value="Option 3">Option 3</div>
    <div contenteditable="true" class="dropdown-item" data-value="Option 4">Option 4</div>
  </div>
</div>

<script>
  const selectedOption = document.getElementById('selectedOption');
  const dropdownOptions = document.getElementById('dropdownOptions');
  const dropdownItems = dropdownOptions.getElementsByClassName('dropdown-item');

  // When an option is clicked, update the selected value
  for (let item of dropdownItems) {
    item.addEventListener('click', () => {
      selectedOption.textContent = item.textContent; // Set selected option text
      dropdownOptions.style.display = 'none'; // Close dropdown
    });
  }

  // Make the dropdown close when the editable field is clicked
  selectedOption.addEventListener('click', () => {
    dropdownOptions.style.display = 'block';
  });

  // Optional: Close dropdown when clicking anywhere else
  document.addEventListener('click', (event) => {
    if (!event.target.closest('.editable-dropdown')) {
      dropdownOptions.style.display = 'none';
    }
  });
</script>

</body>
</html>









<!-- $rowClass = $isNear ? 'near-date' : ''; // Add class if the date is near -->
<!-- echo "<tr class='$rowClass'>"; -->
<!-- .near-date {
    background-color: yellow;
}
 -->