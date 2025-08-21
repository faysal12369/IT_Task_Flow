<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="css files/index1.css">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Rounded:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200" />
    <link rel="shortcut icon" href="sinal-logo.ico" type="image/x-icon">
    <title>La Page D'accueil</title>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>

<body>
    <div class="container">
        <div class="left" id="sidebar">
            <main>
                <img src="sinal-logo.ico" class="img">
                <div class="logo">
                    <button class="sidebar-close-btn">&times;</button>
                    <h2>IT TaskFlow</h2>
                </div>
                <nav>
                    <ul>
                        <li><a href="main.php"><span class="material-symbols-rounded">dashboard</span><span class="title">DashBoard</span></a></li>
                        <li><a href="depense.php"><span class="material-symbols-rounded">task_alt</span><span class="title">Les Consomations</span></a></li>
                        <li><a href="task.php"><span class="material-symbols-rounded">task</span><span class="title">Les Taches</span></a></li>
                        <li><a href="stk.php"><span class="material-symbols-rounded">inventory</span><span class="title">L'inventaire De Stock</span></a></li>
                        <li><a href="Statistique.php"><span class="material-symbols-rounded">equalizer</span><span class="title">Les Statistiques</span></a></li>
                        <li id="moderator-section" style="display: none;">
                            <a href="comptes.php"><span class="material-symbols-rounded">manage_accounts</span><span class="title">Gestion Des Comptes</span></a>
                        </li>
                    </ul>
                </nav>
            </main>
            <div class="logout">
                <h4 class="txt"><strong>Retour à l'Accueil</strong></h4>
                <div class="btn">
                    <button type="button" onclick="logOut()">Se Déconnecter</button>
                </div>
            </div>
        </div>
        <div class="right">
            <div class="top">
                <button class="menu-btn">
                    <span class="material-symbols-rounded">menu</span>
                </button>
                <div class="searchbk">
                    <h2>DashBoard</h2>
                    <div class="inputbk">
                        <span class="material-symbols-rounded">search</span>
                        <input type="search" id="rch" placeholder="Recherche...">
                    </div>
                </div>
                <div class="user">
                    <div class="userImg">
                        <img src="white_circle.png" alt="User Image">
                    </div>
                    <h2 id="username">Veuillez Attendre....</h2>
                    <h2 id="type">Veuillez Attendre....</h2>
                </div>
            </div>
          <div class="ensemble-container">
            <h2>Les Taches:</h2>
            <div class="card-container" id="task-container">
                </div>
            
            <h2>Les Dépenses:</h2>
            <div class="card-container" id="usage-container">
                </div>
</div>
            <div id="pagination" class="pag"></div>
        </div>
    </div>

    <div id="task-details-modal" class="modal">
        <div class="modal-content">
            <span class="modal-close-btn">&times;</span>
            <div id="modal-body">
                </div>
        </div>
    </div>

<script>
$(document).ready(function () {
    // --- Store data globally ---
    let allTasks = [];
    let allUsage = [];

    // --- Sidebar elements and listeners ---
    const menuBtn = document.querySelector('.menu-btn');
    const closeBtn = document.querySelector('.sidebar-close-btn');
    const sidebar = document.querySelector('.left');

    menuBtn.addEventListener('click', () => {
        sidebar.classList.toggle('active');
    });

    closeBtn.addEventListener('click', () => {
        sidebar.classList.remove('active');
    });
    
    // --- Modal elements and functions ---
    const modal = $('#task-details-modal');
    const modalBody = $('#modal-body');
    const modalCloseBtn = $('.modal-close-btn');

    function closeModal() {
        modal.css('display', 'none');
    }

    modalCloseBtn.on('click', closeModal);

    $(window).on('click', function(event) {
        if (event.target == modal[0]) {
            closeModal();
        }
    });

    // --- NEW: Universal Event listener for ALL "Détails" buttons ---
    $(document).on('click', '.view-details-btn', function() {
        const type = $(this).data('type');
        const index = $(this).data('index');
        let item;
        let modalContent = '';

        if (type === 'task') {
            item = allTasks[index];
            if (item) {
                modalContent = `
                    <h2 style="text-transform:capitalize;">Nom De La Tache: ${item.nom_tache}</h2>
                    <h3><strong>Division:</strong> ${item.division}</h3>
                    <h3><strong>État:</strong> ${item.statut_de_la_tache}</h3>
                    <h3><strong>Chargé:</strong> ${item.realisateur}</h3>
                    <h3><strong>Demandeur:</strong> ${item.demandeur}</h3>
                    <h3><strong>Date Début:</strong> ${item.date_debut}</h3>
                    <h3><strong>Date Fin:</strong> ${item.date_fin}</h3>
                `;
            }
        } else if (type === 'usage') {
            item = allUsage[index];
            if (item) {
                // Build the HTML for the Usage modal
                modalContent = `
                    <h2 style="text-transform:capitalize;">Nom De La Dépense: ${item.nom_depense}</h2>
                    <h3><strong>Division:</strong> ${item.division}</h3>
                    <h3><strong>État:</strong> ${item.statut}</h3>
                    <h3><strong>Destinataire:</strong> ${item.person}</h3>
                    <h3><strong>Fournisseur:</strong> ${item.fournisseur}</h3>
                    <h3><strong>Date D'échéance:</strong> ${item.date_dac}</h3>
                    <h3><strong>Description</strong> ${item.commentaire}</h3>
                `;
            }
        }

        // If we have content, inject it into the modal body and display the modal
        if (modalContent) {
            modalBody.html(modalContent);
            modal.css('display', 'block');
        }
    });

    // --- Initial data load function ---
    function initialLoad() {
        $.ajax({
            url: 'script/api/api_task.php',
            dataType: 'json',
            xhrFields: { withCredentials: true },
            success: function (data) {
                if (data.error) {
                    alert(data.error);
                    window.location.href = "index.php";
                    return;
                }
                $('#username').text(data.Nom_user.trim());
                $('#type').text(data.permissions);
                $('#moderator-section').toggle(data.permissions === "modérateur" || data.permissions === "administrateur");
                
                renderSearch(data);
            },
            error: function() {
                $('#task-container').html('<p>Erreur de chargement des données.</p>');
            }
        });
    }
    
    // --- Search functionality ---
    $("#rch").keyup(function() {
        var input = $(this).val().trim();
        searchData(input); // Search on page 1 by default
    });

    function searchData(input, page = 1) {
        $.ajax({
            url: "script/api/api_task.php",
            method: "POST",
            data: { input: input, page: page },
            dataType: "json",
            success: function(data) {
                if (data.error) {
                    console.error(data.error);
                    return;
                }
                renderSearch(data);
            },
            error: function(xhr, status, error) {
                console.error("Search error:", error);
            }
        });
    }

    function renderSearch(data) {
    const taskContainer = $('#task-container').empty();
    const usageContainer = $('#usage-container').empty(); 
    
    // Store data globally - this is from your original working version
    allTasks = data.tasks || [];
    allUsage = data.usage || [];

    // --- LOOP 1: Renders tasks with original column names ---
    allTasks.forEach((task, index) => {
        const taskCard = `
            <div class="card ${task.class}">
                <div class="asset">
                    <h2 style="text-transform: capitalize;">${task.nom_tache}</h2>
                </div>
                <button class="view-details-btn" data-type="task" data-index="${index}">Détails</button>
            </div>
        `;
        taskContainer.append(taskCard);
    });

    allUsage.forEach((usage, index) => {
        const usageCard = `
            <div class="card ${usage.class}">
                <div class="asset">
                    <h2 style="text-transform:capitalize;">${usage.nom_depense}</h2>
                </div>
                <button class="view-details-btn" data-type="usage" data-index="${index}">Détails</button>
            </div>
        `;
        usageContainer.append(usageCard);
    });

    if (data.pagination) {
        const totalPages = Math.max(data.pagination.task_total_pages, data.pagination.usage_total_pages);
        generatePagination(data.pagination.current_page, totalPages);
    }
}

    // --- Pagination generation function ---
    function generatePagination(currentPage, totalPages) {
        const paginationDiv = $('#pagination').empty();
        if (totalPages <= 1) return;

        if (currentPage > 1) {
            paginationDiv.append(`<a href="#" data-page="${currentPage - 1}">&laquo; Précédent</a>`);
        }

        for (let i = 1; i <= totalPages; i++) {
            paginationDiv.append(`<a href="#" class="${i === currentPage ? 'active' : ''}" data-page="${i}">${i}</a>`);
        }

        if (currentPage < totalPages) {
            paginationDiv.append(`<a href="#" data-page="${currentPage + 1}">Suivant &raquo;</a>`);
        }
    }

    // --- Event handler for pagination links ---
    $('#pagination').on('click', 'a', function(event) {
        event.preventDefault();
        const page = parseInt($(this).data('page'));
        const input = $("#rch").val().trim();
        searchData(input, page);
    });

    // --- Initial Load ---
    initialLoad(); 
});

// This should be outside the document.ready but still in a <script> tag
function logOut() {
    window.location.href = "index.php";
}
</script>

</body>
</html>