<!DOCTYPE html>
<html lang="fr">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="css files/task1.css">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Rounded:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200" />
    <link rel="shortcut icon" href="sinal-logo.ico" type="image/x-icon">
    <title>Les Consommations</title>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>

<body>
    <div class="container">
        <div class="left" id="sidebar">
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
                <h4><strong>Retour à l'Accueil</strong></h4>
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
                    <h2>Tableau De Fourniture</h2>
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
                <button type="button" class="add_tac" onclick="show()">Ajouter Une Fourniture</button>
                <table class="t1" id="t1">
                    <thead>
                        <tr>
                            <th>Nom De La Dépense</th>
                            <th>Numéro de Suivi Facture 
                                Equipement</th>
                            <th>Date D'acquisition/
                                D'échéance</th>
                            <th>Fournisseur</th>
                            <th>Division</th>
                            <th>Bénéficiaire</th>
                            <th>Adresse</th>
                            <th>Commentaire</th>
                            <th>Statut De La Dépense</th>
                            <th id="permission-section" style="display: none;">Option</th>
                        </tr>
                    </thead>
                    <tbody></tbody>
                </table>
                <div class="add_tach" style="display: none;">
                    <form action="script/api/api_cons.php" method="POST" onsubmit="handleSubmit(event)">
                        <div class="table01">
                            <h2>Ajouter une Nouvelle Dépense</h2>
                            <input type="text" name="nom_depense" placeholder="Nom De La Dépense" required>
                            <input type="text" name="ref" placeholder="Référence De La Fourniture" >
                            <input type="date" name="date_dac" placeholder="Date D'acquisition" required>
                            <input type="text" name="fournisseur" placeholder="fournisseur_De_La_Dépense" required>
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
                            <input type="text" name="adresse" placeholder="Adresse De Magazin" required>
                            <input type="text" name="commentaire" placeholder="Commentaire de la Dépense">
                            <input type="text" name="description" placeholder="localisation De L'équipement (Etage+ Bureau)" required>
                            <input type="text" name="job" placeholder="Job" required>
                            <input type="text" name="person" placeholder="Personne" required>
                            <select name="statut">
                                <option value="pas_encore">Elle a été démarré</option>
                                <option value="en_cours">Elle est En Cours</option>
                                <option value="terminé">Elle est terminé</option>
                            </select>
                            <button type="submit" class="add_tac" name="ajouter_dep">Ajouter</button>
                            <button type="button" class="ext" onclick="exit()">Fermer </button>
                        </div>
                    </form>
                    <p id="message"></p>
                </div>
            </div>
            <div id="pagination" class="pag"></div>
        </div>
    </div>
    <script>
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

    closeBtn.addEventListener('click', () => {
        sidebar.classList.remove('active');
    });
});
        $(document).ready(function() {
            let currentPage = 1;
            const consPerPage = 12;

            function loadcons(page) {
                console.log(`Loading cons for page: ${page}`);

                $.ajax({
                    url: 'script/api/api_cons.php',
                    dataType: 'json',
                    data: {
                        page: page,
                        limit: consPerPage
                    },
                    xhrFields: {
                        withCredentials: true
                    },
                    success: function(data) {
                        console.log("Data received:", data);


                        if (data.error) {
                            alert(data.error);
                            window.location.href = "index.php";
                            return;
                        }

                        $('#username').text(data.Nom_user);
                        $('#type').text(data.permissions);
                        $('#permission-section').toggle(data.permissions === "administrateur" || data.permissions === "modérateur");
                        $('#moderator-section').toggle(data.permissions === "modérateur" || data.permissions === "administrateur");
                        const taskTable = $('tbody');
                        taskTable.empty();

                        data.cons.forEach(task => {
                            const isEditable = (data.permissions === "modérateur" || data.permissions === "administrateur");
                            const admin= (data.permissions === "administrateur");
                            const taskRow = `
                            <tr class="${task.class === 'urgent_container' ? 'urgent' : 'NoUrgent'}">
                            <td contenteditable="${isEditable}" id="editNom${task.id_depense}">${task.nom_depense}</td>
                            <td contenteditable="${isEditable}" id="editref${task.id_depense}">${task.ref}</td>
                            <td contenteditable="${isEditable}" id="editdd${task.id_depense}">${task.date_dac}</td>
                            <td contenteditable="${isEditable}" id="editdem${task.id_depense}">${task.fournisseur}</td>
                            <td>
                ${isEditable ? `
                    <select id="editdiv${task.id_depense}">
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
                </select>
            ` : `
                <span id="editdiv${task.id_depense}">
                    ${
                        {
                            'DG': 'DG',
                            'DS': 'DS',
                            'Optique': 'Optique',
                            'Acuitis': 'Acuitis',
                            'Biotug': 'Biotug',
                            'khm': 'Agence Khmisti',
                            'tiz': 'Agence Tizi-Ouzo',
                            'stf': 'Agence Sétif',
                            'alg': 'Agence Alger',
                            'bej': 'Agence Béjaia'
                        }[task.division] || task.division
                    }
                </span>
            `}
        </td>
        <td contenteditable="${isEditable}" id="editprsn${task.id_depense}">${task.person}</td>
        <td contenteditable="${isEditable}" id="editadr${task.id_depense}">${task.adresse}</td>
        <td contenteditable="${isEditable}" id="editdes${task.id_depense}">${task.commentaire}</td>
        const statut = (task.statut || '').trim();

<td>
  ${isEditable ? `
    <select id="editstat${task.id_depense}">
      <option value="pas_encore" ${task.statut === 'pas_encore' ? 'selected' : ''}>La Tâche n'a pas été démarrée</option>
      <option value="en_cours" ${task.statut === 'en_cours' ? 'selected' : ''}>Elle est En Cours</option>
      <option value="terminé" ${task.statut === 'terminé' ? 'selected' : ''}>Elle est terminée</option>
    </select>
  ` : `
                <span id="editstat${task.id_depense}">
                    ${
                        {
                            'pas_encore': 'La Tâche n\'a pas été démarrée',
                            'en_cours': 'Elle est En Cours',
                            'terminé': 'Elle est terminée'
                        }[task.statut] || task.statut
                    }
                </span>
            `}
        </td>

        ${isEditable ? `
        <td>
            <button type="button" onclick="saveChanges(${task.id_depense})" class="action-btn edit-btn">
                <span class="material-symbols-rounded">edit</span>
            </button>
            <button type="button" onclick="DeleteChanges(${task.id_depense})" class="action-btn delete-btn">
                <span class="material-symbols-rounded">delete</span>
            </button>
        </td>
        ` : ''}
    </tr>
    `;

                            taskTable.append(taskRow);
                        });

                        generatePagination(data.pagination.current_page, data.pagination.total_pages);
                    }
                });
            }

            function generatePagination(currentPage, totalPages) {
                const paginationDiv = $('#pagination');
                paginationDiv.empty();
                if (totalPages <= 1) return;
                if (currentPage > 1) {
                    paginationDiv.append(`<a href="#" data-page="${currentPage - 1}">&laquo; Previous</a>`);
                }
                for (let i = 1; i <= totalPages; i++) {
                    if (i === currentPage) {
                        paginationDiv.append(`<a href="#" class="active" data-page="${i}">${i}</a>`);
                    } else {
                        paginationDiv.append(`<a href="#" data-page="${i}">${i}</a>`);
                    }
                }
                if (currentPage < totalPages) {
                    paginationDiv.append(`<a href="#" data-page="${currentPage + 1}">Next &raquo;</a>`);
                }
                $('#pagination a').click(function(event) {
                    event.preventDefault();
                    const page = parseInt($(this).data('page'));
                    loadcons(page);
                });
            }

            loadcons(currentPage);
        });


        // Show/Hide form
        let display = 0;
        const table = document.querySelector('.t1');
        const table2 = document.querySelector('.add_tach');
        const pag = document.querySelector('.pag');

        function show() {
            if (display === 0) {
                table.style.display = 'none';
                table2.style.display = 'grid';
                pag.style.display = 'none';
                display = 1;
            }
        }

        function exit() {
            if (display === 1) {
                table.style.display = 'table';
                table2.style.display = 'none';
                pag.style.display = 'flex';
                display = 0;
            }
        }

        // LogOut function
        function logOut() {
            window.location.href = "index.php";
        }

        // Save Changes
        function saveChanges(taskId) {
            const updatedTask = {
                id_depense: taskId,
                nom_depense: document.getElementById(`editNom${taskId}`).innerText,
                date_dac: document.getElementById(`editdd${taskId}`).innerText,
                ref: document.getElementById(`editref${taskId}`).innerText,
                fournisseur: document.getElementById(`editdem${taskId}`).innerText,
                division: document.getElementById(`editdiv${taskId}`).value,
                adresse: document.getElementById(`editadr${taskId}`).innerText,
                person:document.getElementById(`editprsn${taskId}`).innerText,
                commentaire: document.getElementById(`editdes${taskId}`).innerText,
                statut: document.getElementById(`editstat${taskId}`).value,
            };

            fetch('script/api/api_cons.php', {
                    method: 'PUT',
                    headers: {
                        'Content-Type': 'application/json'
                    },
                    body: JSON.stringify(updatedTask)
                })
                .then(response => response.json())
                .then(data => {
                    if (data.error) {
                        alert("Erreur : " + data.error);
                    } else {
                        alert("Tâche mise à jour avec succès !");
                    }
                })
                .catch(error => console.error("Erreur lors de la mise à jour :", error));
        }
        // Delete Changes
        function DeleteChanges(taskId) {
            if (!confirm("Voulez-vous vraiment supprimer cette tâche ?")) {
                return;
            }
            fetch('script/api/api_cons.php', {
                    method: 'DELETE',
                    headers: {
                        'Content-Type': 'application/json'
                    },
                    body: JSON.stringify({
                        id_depense: taskId
                    })
                })
                .then(response => response.json())
                .then(data => {
                    if (data.error) {
                        alert("Erreur : " + data.error);
                    } else {
                        alert("Tâche supprimée avec succès !");
                        location.reload();
                    }
                })
                .catch(error => console.error("Erreur lors de la suppression :", error));
        }

        $(document).ready(function() {
            $("#rch").keyup(function() {
                var input = $(this).val().trim();

                if (input !== "") {
                    searchData(input);
                } else {
                    searchData("");
                }
            });

            function searchData(input) {
                $.ajax({
                    url: "script/api/api_cons.php",
                    method: "POST",
                    data: {
                        input: input
                    },
                    dataType: "json",
                    success: function(data) {
                        if (data.error) {
                            console.error(data.error);
                            return;
                        }
                        rendercons(data.cons, data.pagination);
                    },
                    error: function(xhr, status, error) {
                        console.error("Search error:", error);
                    }
                });
            }

            function rendercons(cons, pagination) {
                $('tbody').empty();
                cons.forEach(task => {
                    const contenteditable = ($('#type').text() === "modérateur" || $('#type').text() === "administrateur") ? "true" : "false";
                    const admini= ($('#type').text() === "administrateur") ? true : false;
                    const option = (contenteditable === "true");
                    const taskRow = `
                <tr class="${task.class === 'urgent_container' ? 'urgent'   : ''}">
                    <td contenteditable="${contenteditable}" id="editNom${task.id_depense}">${task.nom_depense}</td>
                    <td contenteditable="${contenteditable}" id="editfd${task.id_depense}">${task.ref}</td>
                    <td contenteditable="${contenteditable}" id="editdd${task.id_depense}">${task.date_dac}</td>
                    <td contenteditable="${contenteditable}" id="editdem${task.id_depense}">${task.fournisseur}</td>
                    <td>
                        ${option ? `
                            <select id="editdiv${task.id_depense}">
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
                            </select>
                        ` : `
                            <span id="editdiv${task.id_depense}">
                                ${{
                                    'DG': 'DG',
                                    'DS': 'DS',
                                    'Optique': 'Optique',
                                    'Acuitis': 'Acuitis',
                                    'Biotug': 'Biotug',
                                    'khm': 'Agence Khmisti',
                                    'tiz': 'Agence Tizi-Ouzo',
                                    'stf': 'Agence Sétif',
                                    'alg': 'Agence Alger',
                                    'bej': 'Agence Béjaia'
                                }[task.division] || task.division}
                            </span>
                        `}
                    </td>
                    <td contenteditable="${contenteditable}" id="editadr${task.id_depense}">${task.person}</td>
                    <td contenteditable="${contenteditable}" id="editadr${task.id_depense}">${task.adresse}</td>
                    <td contenteditable="${contenteditable}" id="editdes${task.id_depense}">${task.commentaire}</td>
                    <td>
                        ${option ? `
                            <select id="editstat${task.id_depense}">
                                <option value="pas_encore" ${task.statut === 'pas_encore' ? 'selected' : ''}>La Tâche n'a pas été démarrée</option>
                                <option value="en_cours" ${task.statut === 'en_cours' ? 'selected' : ''}>Elle est En Cours</option>
                                <option value="terminé" ${task.statut === 'terminé' ? 'selected' : ''}>Elle est terminée</option>
                            </select>
                        ` : `
                            <span id="editstat${task.id_depense}">${task.statut}
                            ${{
                                'pas_encore': 'La Tâche n\'a pas été démarrée',
                                'en_cours': 'Elle est En Cours',
                                'terminé': 'Elle est terminée'
                            }[task.statut] || task.statut}</span>
                        `}
                    </td>
                    <td>
                        ${option ? `
                            <button type="button" onclick="saveChanges(${task.id_depense})" class="action-btn edit-btn">
                            <span class="material-symbols-rounded">edit</span>
                        </button>
                        <button type="button" onclick="DeleteChanges(${task.id_depense})" class="action-btn delete-btn">
                            <span class="material-symbols-rounded">delete</span>
                        </button>
                        ` : ''}
                    </td>
                </tr>
            `;
                    $('tbody').append(taskRow);
                });
                generatePagination(pagination.current_page, pagination.total_pages);
            }

            function generatePagination(currentPage, totalPages) {
                const paginationDiv = $('#pagination');
                paginationDiv.empty();

                if (totalPages <= 1) return;

                if (currentPage > 1) {
                    paginationDiv.append(`<a href="#" data-page="${currentPage - 1}">&laquo; Previous</a>`);
                }
                for (let i = 1; i <= totalPages; i++) {
                    paginationDiv.append(`<a href="#" class="${i === currentPage ? 'active' : ''}" data-page="${i}">${i}</a>`);
                }
                if (currentPage < totalPages) {
                    paginationDiv.append(`<a href="#" data-page="${currentPage + 1}">Next &raquo;</a>`);
                }

                $('#pagination a').click(function(event) {
                    event.preventDefault();
                    const page = parseInt($(this).data('page'));
                    loadPage(page);
                });
            }

            function loadPage(page) {
                var input = $("#rch").val().trim();
                $.ajax({
                    url: "script/api/api_cons.php",
                    method: "POST",
                    data: {
                        input: input,
                        page: page
                    },
                    dataType: "json",
                    success: function(data) {
                        if (data.error) {
                            console.error(data.error);
                            return;
                        }
                        rendercons(data.cons, data.pagination);
                    },
                    error: function(xhr, status, error) {
                        console.error("Pagination error:", error);
                    }
                });
            }
        });

        // Handle form submission

       function handleSubmit(event) {
    event.preventDefault();

    const form = event.target;
    const formData = new FormData(form);
    const jsonData = {};

    formData.forEach((value, key) => {
        jsonData[key] = value;
    });

    jsonData['ajouter_depense'] = true;

    fetch(form.action, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify(jsonData)
    })
    .then(response => response.text())
    .then(data => {
        console.log('Response:', data);
        document.getElementById('message').innerText = 'Dépense ajoutée avec succès !';
        setTimeout(() => {
            location.reload();
        }, 2000);
    })
    .catch(error => {
        console.log('Error:', error);
        document.getElementById('message').innerText = `Erreur de l'ajout de la dépense.`;
    });
}

    </script>
</body>
</html>
