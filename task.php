<!DOCTYPE html>
<html lang="fr">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="css files/task1.css">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Rounded:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200" />
    <link rel="shortcut icon" href="sinal-logo.ico" type="image/x-icon">
    <title>Les Tâches</title>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>

<body>
    <div class="container">
        <div class="left">
            <main>
                <img src="sinal-logo.ico" class="img" >
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
                <h4><strong>Retour à L'accueil</strong></h4>
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
                    <h2>Tableau De Taches</h2>
                    <div class="inputbk">
                        <input type="text" id="rch" placeholder="Recherche...">
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

            <div class="tbl">
                <button type="button" class="add_tac" onclick="show()">Ajouter Une Tâche</button>
                <table class="t1" id="t1">
                    <thead>
                        <tr>
                            <th>Nom De La Tâche</th>
                            <th>Date Début</th>
                            <th>Date Fin</th>
                            <th>Demandeur</th>
                            <th>Division</th>
                            <th>Réalisateur</th>
                            <th>Commentaire</th>
                            <th>Statut De La Tâche</th>
                            <th id="permission-section" style="display: none;" >Option</th>
                        </tr>
                    </thead>
                    <tbody></tbody>
                </table>
                    <div class="add_tach" style="display: none;">
                        <form id="taskForm" action="script/api/api_task1.php" method="POST" onsubmit="handleSubmit(event)">
                        <div class="table01">
                        <h2>Ajouter une Nouvelle Tâche</h2>
                        <input type="text" name="nom_tache" placeholder="Nom De La Tâche" required>
                        <input type="date" name="date_debut" required>
                        <input type="date" name="date_fin">
                        <input type="text" name="demandeur" placeholder="Demandeur" required>
                        <select name="division" required>
                            <option value="DG">DG</option>
                            <option value="DS">DS</option>
                            <option value="Optique">Optique</option>
                            <option value="Acuitis">Acuitis</option>
                            <option value="Biotug">Biotug</option>
                            <option value="Khm">Agence Khmissti</option>
                            <option value="tiz">Agence Tizi</option>
                            <option value="stf">Agence Sétif</option>
                            <option value="alg">Agence Alger</option>
                            <option value="bej">Agence Béjaia</option>
                        </select>
                        <input type="text" name="realisateur" placeholder="Réalisateur" required>
                        <input type="text" name="description" placeholder="Commentaire">
                        <select name="statut_de_la_tache">
                            <option value="pas_encore">La Tâche n'a pas été démarrée</option>
                            <option value="en_cours">Elle est En Cours</option>
                            <option value="terminé">Elle est terminée</option>
                        </select>
                        
                        <select name="movement_task" id="movement_type" style="display: none;">
                            <option value="">-- Choisissez le type de mouvement --</option>
                            <option value="in">Entrée</option>
                            <option value="out">Sortie</option>
                        </select>
                        
                        <p id="message"></p>
                        <button type="submit" class="add_tac" name="ajouter_tache">Ajouter</button>
                        <button type="button" class="ext" onclick="exit()">Fermer</button>
                    </div>
                </form>
            </div>
            </div>
            <div id="pagination" class="pag">
            </div>
        </div>
    </div>
    <script>
// GLOBAL: equipment types list (accessible everywhere)
const equipmentTypes = [
    "adaptateur", "ordinateur portable", "pc portable", "laptop", "unité centrale",
    "écran", "moniteur", "baie de stockage", "scanner",
    "téléphone fix", "fax", "téléphone fax", "téléphone mobile", "téléphone", "onduleur",
    "routeur", "switch", "serveur", "disque dur externe", "clé usb", "projecteur",
    "modem", "point d'accès wi-fi", "caméra de surveillance", "baie de brassage",
    "kit de nettoyage", "imprimante", "ruban", "kit de néttoyage", "telephone", "telephone fix",
    "telephone fax", "telephone mobile"
];

document.addEventListener('DOMContentLoaded', function () {
    const taskNameInput = document.querySelector('input[name="nom_tache"]');
    const movementTypeSelect = document.querySelector('select[name="movement_task"]');
    const descriptionInput = document.querySelector('input[name="description"]');

    if (taskNameInput && movementTypeSelect && descriptionInput) {
        taskNameInput.addEventListener('input', function () {
            const currentTaskName = taskNameInput.value.toLowerCase().trim();
           const isTonerTask = currentTaskName.includes('toner') &&
    /(imprimante|l'imprimante|d'imprimante)/i.test(currentTaskName);
  
    const isAnEquipmentTask = !isTonerTask && equipmentTypes.some(keyword => currentTaskName.includes(keyword));

            if (isTonerTask) {
                movementTypeSelect.style.display = 'none';
                movementTypeSelect.removeAttribute('required');
                descriptionInput.placeholder = 'Veuillez mettre le compteur du toner';
            } else if (isAnEquipmentTask) {
                movementTypeSelect.style.display = 'block';
                movementTypeSelect.setAttribute('required', 'required');
                descriptionInput.placeholder = "localisation De L'équipement";
            } else {
                movementTypeSelect.style.display = 'none';
                movementTypeSelect.removeAttribute('required');
                descriptionInput.placeholder = 'Commentaire';
            }
        });
    }
});

// Menu toggle
$(document).ready(function () {
    const menuBtn = document.querySelector('.menu-btn');
    const closeBtn = document.querySelector('.sidebar-close-btn');
    const sidebar = document.querySelector('.left');

    menuBtn.addEventListener('click', () => {
        sidebar.classList.toggle('active');
    });
    closeBtn.addEventListener('click', () => {
        sidebar.classList.remove('active');
    });

    // Pagination & load tasks
    let currentPage = 1;
    const tasksPerPage = 12;

    function loadTasks(page) {
        $.ajax({
            url: 'script/api/api_task1.php',
            dataType: 'json',
            data: { page, limit: tasksPerPage },
            xhrFields: { withCredentials: true },
            success: function (data) {
                if (data.error) {
                    alert(data.error);
                    window.location.href = "main.php";
                    return;
                }

                $('#username').text(data.Nom_user);
                $('#type').text(data.permissions);
                $('#permission-section').toggle(data.permissions === "administrateur" || data.permissions === "modérateur");
                $('#moderator-section').toggle(data.permissions === "modérateur" || data.permissions === "administrateur");

                renderTasks(data.tasks, data.permissions);
                generatePagination(data.pagination.current_page, data.pagination.total_pages);
            },
            error: function (xhr, status, error) {
                console.error("Load tasks error:", error);
            }
        });
    }

    function renderTasks(tasks, permissions) {
        const taskTable = $('tbody');
        taskTable.empty();

        const isEditable = (permissions === "modérateur" || permissions === "administrateur");

        tasks.forEach(task => {
            const contenteditable = isEditable ? "true" : "false";
            const taskRow = `
<tr class="${task.class === 'urgent_container' ? 'urgent' : 'NoUrgent'}">
    <td contenteditable="${contenteditable}" id="editNom${task.id_tache}">${task.nom_tache}</td>
    <td contenteditable="${contenteditable}" id="editdd${task.id_tache}">${task.date_debut}</td>
    <td contenteditable="${contenteditable}" id="editfd${task.id_tache}">${task.date_fin}</td>
    <td contenteditable="${contenteditable}" id="editdem${task.id_tache}">${task.demandeur}</td>
    <td>
        ${isEditable ? `
            <select id="editdiv${task.id_tache}">
                <option value="DG" ${task.division === 'DG' ? 'selected' : ''}>DG</option>
                <option value="DS" ${task.division === 'DS' ? 'selected' : ''}>DS</option>
                <option value="Optique" ${task.division === 'Optique' ? 'selected' : ''}>Optique</option>
                <option value="Acuitis" ${task.division === 'Acuitis' ? 'selected' : ''}>Acuitis</option>
                <option value="Biotug" ${task.division === 'Biotug' ? 'selected' : ''}>Biotug</option>
                <option value="khm" ${task.division === 'khm' ? 'selected' : ''}>Agence Khmisti</option>
                <option value="tiz" ${task.division === 'tiz' ? 'selected' : ''}>Agence Tizi-Ouzo</option>
                <option value="stf" ${task.division === 'stf' ? 'selected' : ''}>Agence Sétif</option>
                <option value="alg" ${task.division === 'alg' ? 'selected' : ''}>Agence Alger</option>
                <option value="bej" ${task.division === 'bej' ? 'selected' : ''}>Agence Béjaia</option>
            </select>` : `<span id="editdiv${task.id_tache}">${task.division}</span>`}
    </td>
    <td contenteditable="${contenteditable}" id="editadr${task.id_tache}">${task.realisateur}</td>
    <td contenteditable="${contenteditable}" id="editdes${task.id_tache}">${task.description || "Pas de description disponible"}</td>
    <td>
        ${isEditable ? `
            <select id="editstat${task.id_tache}">
                <option value="pas_encore" ${task.statut_de_la_tache === 'pas_encore' ? 'selected' : ''}>La Tâche n'a pas été démarrée</option>
                <option value="en_cours" ${task.statut_de_la_tache === 'en_cours' ? 'selected' : ''}>Elle est En Cours</option>
                <option value="terminé" ${task.statut_de_la_tache === 'terminé' ? 'selected' : ''}>Elle est terminée</option>
            </select>` : `<span id="editstat${task.id_tache}">${task.statut_de_la_tache}</span>`}
    </td>
    ${isEditable ? `
    <td>
        <button onclick="saveChanges(${task.id_tache})" class="action-btn edit-btn">
            <span class="material-symbols-rounded">edit</span>
        </button>
        <button onclick="DeleteChanges(${task.id_tache})" class="action-btn delete-btn">
            <span class="material-symbols-rounded">delete</span>
        </button>
    </td>` : ''}
</tr>`;
            taskTable.append(taskRow);
        });
    }

    function generatePagination(currentPage, totalPages) {
        const paginationDiv = $('#pagination');
        paginationDiv.empty();

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

        $('#pagination a').click(function (e) {
            e.preventDefault();
            const page = parseInt($(this).data('page'));
            loadTasks(page);
        });
    }

    // Initial load
    loadTasks(currentPage);

    // Search
    $("#rch").keyup(function () {
        const input = $(this).val().trim();
        searchData(input);
    });

    function searchData(input) {
        $.ajax({
            url: "script/api/api_task1.php",
            method: "POST",
            data: { input },
            dataType: "json",
            success: function (data) {
                if (!data.error) {
                    renderTasks(data.tasks, data.permissions);
                }
            },
            error: function (xhr, status, error) {
                console.error("Search error:", error);
            }
        });
    }
});

// Save task changes
function saveChanges(taskId) {
    const updatedTask = {
        id_tache: taskId,
        nom_tache: document.getElementById(`editNom${taskId}`).innerText,
        date_debut: document.getElementById(`editdd${taskId}`).innerText,
        date_fin: document.getElementById(`editfd${taskId}`).innerText,
        demandeur: document.getElementById(`editdem${taskId}`).innerText,
        division: document.getElementById(`editdiv${taskId}`).value,
        realisateur: document.getElementById(`editadr${taskId}`).innerText,
        description: document.getElementById(`editdes${taskId}`).innerText,
        statut_de_la_tache: document.getElementById(`editstat${taskId}`).value
    };

    fetch('script/api/api_task1.php', {
        method: 'PUT',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(updatedTask)
    })
    .then(response => response.json())
    .then(data => {
        if (data.error) alert("Erreur : " + data.error);
        else alert("Tâche mise à jour avec succès !");
    })
    .catch(error => console.error("Erreur lors de la mise à jour :", error));
}

// Delete task
function DeleteChanges(taskId) {
    if (!confirm("Voulez-vous vraiment supprimer cette tâche ?")) return;

    fetch('script/api/api_task1.php', {
        method: 'DELETE',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ id_tache: taskId })
    })
    .then(response => response.json())
    .then(data => {
        if (data.error) alert("Erreur : " + data.error);
        else {
            alert("Tâche supprimée avec succès !");
            location.reload();
        }
    })
    .catch(error => console.error("Erreur lors de la suppression :", error));
}

// Form submit validation
function handleSubmit(event) {
    event.preventDefault();
    const form = event.target;
    const formData = new FormData(form);

    const taskName = formData.get('nom_tache').toLowerCase().trim();
const isTonerTask = taskName.includes('toner') && /(imprimante|l'imprimante|d'imprimante)/i.test(taskName);
const isAnEquipmentTask = !isTonerTask && equipmentTypes.some(keyword => taskName.includes(keyword));
    if (isAnEquipmentTask) {
    const movementType = formData.get('movement_task');
    if (!movementType) { 
        document.getElementById('message').innerText = "Pour un équipement, le type de mouvement est requis.";
        return;
    }
}

    const dateDebut = new Date(formData.get('date_debut'));
    const dateFin = new Date(formData.get('date_fin'));

    if (dateDebut > dateFin) {
        document.getElementById('message').innerText = "La date de début ne peut pas être postérieure à la date de fin.";
        return;
    }

    formData.append('ajouter_tache', '1');

    fetch(form.action, {
        method: 'POST',
        body: formData
    })
    .then(response => response.text())
    .then(() => {
        document.getElementById('message').innerText = 'Tâche ajoutée avec succès!';
        setTimeout(() => location.reload(), 1000);
    })
    .catch(() => {
        document.getElementById('message').innerText = `Erreur lors de l'ajout de la tâche.`;
    });
}

// Show/exit forms
let display = 0;
function show() {
    if (display === 0) {
        document.querySelector('.t1').style.display = 'none';
        document.querySelector('.add_tach').style.display = 'grid';
        document.querySelector('.pag').style.display = 'none';
        display = 1;
    }
}
function exit() {
    if (display === 1) {
        document.querySelector('.t1').style.display = 'table';
        document.querySelector('.add_tach').style.display = 'none';
        document.querySelector('.pag').style.display = 'flex';
        display = 0;
    }
}

// Logout
function logOut() {
    window.location.href = "index.php";
}

</script>
</body>
</html>