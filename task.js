function task() {
    var cardContainer = document.querySelector('.card-container');
    var tableDiv = document.querySelector('.table');

    // Replace the card-container with the table div
    cardContainer.style.display = 'none'; 
    tableDiv.style.display = 'block'; 
}
function exit(){
var cardContainer = document.querySelector('.card-container');
var tableDiv = document.querySelector('.table');
cardContainer.style.display = 'block'; 
tableDiv.style.display = 'none'; 
}
