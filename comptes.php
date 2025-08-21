<!DOCTYPE html>
<html lang="fr">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="css files/compte1.css">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Rounded:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200" />
    <title>Les Tâches</title>
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
                    <li><a href="main.php">
                        <span class="material-symbols-rounded">dashboard</span><span class="title">DashBoard</span></a></li>
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
                <h4><strong>Retour A L'accueil</strong></h4>
                <div class="btn">
                    <button type="button" onclick="logOut()">Se Déconnecter</button>
                </div>
            </div>
        </div>

        <!-- Right Main Content Area -->
        <div class="right">
            <div class="top">
                 <button class="menu-btn">
                    <span class="material-symbols-rounded">menu</span>
                </button>
                <div class="searchbk">
                    <h2>Tableau Des Comptes</h2>
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
                <button type="button" class="add_acc" onclick="show()">Ajouter Un Compte</button>
                <table class="t1">
                    <thead>
                        <tr>
                            <th>Nom</th>
                            <th>Username</th>
                            <th>Email</th>
                            <th>Date D'intégration</th>
                            <th>Permission</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                    </tbody>
                </table>
                <div class="add" style="display: none;">
                    <form action="script/api/api_acc.php" method="POST" onsubmit="handleSubmit(event)">
                        <div class="table01">
                            <h3>Ajouter un nouveau compte</h3>
                            <input type="text" name="Nom_Complet" placeholder="Nom Complet" required>
                            <input type="text" name="Username" placeholder="Username" required>
                            <input type="email" name="Email" placeholder="Email" required>
                            <input type="password" name="Password" placeholder="Password" required>
                            <input type="date" name="Date_D_Integration" required>
                            <select name="Permission">
                                <option value="administrateur">administrateur</option>
                                <option value="modérateur">modérateur</option>
                                <option value="compte standard">compte standard</option>
                            </select>
                            <p id="message" ></p>
                        </div>
                        <button type="submit" class="add_acc" name="ajouter_compte">Ajouter </button>
                        <button type="button" class="ext" onclick="exit()">Fermer </button>
                    </form>
                </div>
                <div id="pagination" class="pag">
                    <!-- Pagination links will be generated here -->
                </div>
                <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
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
                        const usersPerPage = 12;

                        function loadUsers(page) {
                            $.ajax({
                                url: 'script/api/api_acc.php',
                                dataType: 'json',
                                data: {
                                    page: page,
                                    limit: usersPerPage
                                },
                                xhrFields: {
                                    withCredentials: true
                                },
                                success: function(data) {
                                    if (data.error) {
                                        alert(data.error);
                                        window.location.href = "index.php";
                                        return;
                                    }

                                    $('#username').text(data.Nom_user);
                                    $('#type').text(data.permissions);

                                    if (data.permissions === 'modérateur') {
                                        $('#moderator-section').show();
                                    }

                                    if (data.permissions === 'administrateur' || data.permissions === 'modérateur') {
                                        $('#admin-section').show();
                                        $('#moderator-section').show();
                                        $('#permission-section').show();
                                    }

                                    const userTable = $('tbody');
                                    userTable.empty();

                                    data.users.forEach(user => {
                                        const isEditable = (data.permissions === "modérateur" || data.permissions === "administrateur");
                                        const contenteditable = isEditable ? "true" : "false";

                                        const userRow = `
                        <tr>
                            <td contenteditable="${contenteditable}" id="editNom${user.ID_De_Compte}">${user.Nom_Complet}</td>
                            <td contenteditable="${contenteditable}" id="editUsername${user.ID_De_Compte}">${user.Username}</td>
                            <td contenteditable="${contenteditable}" id="editEmail${user.ID_De_Compte}">${user.Email}</td>
                            <td contenteditable="${contenteditable}" id="editDate${user.ID_De_Compte}">${user.Date_D_Integration}</td>
                            <td>
                                <select id="editPerm${user.ID_De_Compte}">
                                    <option value="administrateur" ${user.Permission === 'administrateur' ? 'selected' : ''}>Administrateur</option>
                                    <option value="modérateur" ${user.Permission === 'modérateur' ? 'selected' : ''}>Modérateur</option>
                                    <option value="compte standard" ${user.Permission === 'compte standard' ? 'selected' : ''}>Utilisateur Normal</option>
                                </select>
                            </td>
                            <td>
                                ${isEditable ? `
                                    <button onclick="saveUser(${user.ID_De_Compte})" class="action-btn edit-btn"">
                                        <span class="material-symbols-rounded">edit</span>
                                    </button>
                                    <button onclick="deleteUser(${user.ID_De_Compte})" class="action-btn delete-btn"">
                                        <span class="material-symbols-rounded">delete</span>
                                    </button>
                                ` : ''}
                            </td>
                        </tr>
                    `;
                                        userTable.append(userRow);
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
                                paginationDiv.append(`<a href="#" class="${i === currentPage ? 'active' : ''}" data-page="${i}">${i}</a>`);
                            }

                            if (currentPage < totalPages) {
                                paginationDiv.append(`<a href="#" data-page="${currentPage + 1}">Next &raquo;</a>`);
                            }

                            $('#pagination a').click(function(e) {
                                e.preventDefault();
                                const page = parseInt($(this).data('page'));
                                loadUsers(page);
                            });
                        }

                        // Save User
                        window.saveUser = function(userId) {
                            const updatedUser = {
                                ID_De_Compte: userId,
                                Nom_Complet: document.getElementById(`editNom${userId}`).innerText,
                                Username: document.getElementById(`editUsername${userId}`).innerText,
                                Email: document.getElementById(`editEmail${userId}`).innerText,
                                Date_D_Integration: document.getElementById(`editDate${userId}`).innerText,
                                Permission: document.getElementById(`editPerm${userId}`).value,
                            };


                            fetch('script/api/api_acc.php', {
                                    method: 'PUT',
                                    headers: {
                                        'Content-Type': 'application/json'
                                    },
                                    body: JSON.stringify(updatedUser)
                                })
                                .then(response => response.json())
                                .then(data => {
                                    if (data.error) {
                                        alert("Erreur : " + data.error);
                                    } else {
                                        alert("Utilisateur mis à jour avec succès !");
                                    }
                                })
                                .catch(error => console.error("Erreur lors de la mise à jour :", error));
                        };

                        // Delete User
                        window.deleteUser = function(userId) {
                            if (!confirm("Voulez-vous vraiment supprimer cet utilisateur ?")) return;

                            fetch('script/api/api_acc.php', {
                                    method: 'DELETE',
                                    headers: {
                                        'Content-Type': 'application/json'
                                    },
                                    body: JSON.stringify({
                                        ID_De_Compte: userId
                                    })
                                })
                                .then(response => response.json())
                                .then(data => {
                                    if (data.error) {
                                        alert("Erreur : " + data.error);
                                    } else {
                                        alert("Utilisateur supprimé avec succès !");
                                        location.reload();
                                    }
                                })
                                .catch(error => console.error("Erreur lors de la suppression :", error));
                        };

                        // Recherche en temps réel
                        $("#rch").keyup(function() {
                            var input = $(this).val().trim();

                            function renderUsers(users) {
                                $('tbody').empty();
                                users.forEach(user => {
                                    const contenteditable = ($('#type').text() === "modérateur" || $('#type').text() === "administrateur") ? "true" : "false";
                                    const option = ($('#type').text() === "modérateur" || $('#type').text() === "administrateur");

                                    const userRow = `
                <tr>
                    <td contenteditable="${contenteditable}" id="editNom${user.ID_De_Compte}">${user.Nom_Complet}</td>
                    <td contenteditable="${contenteditable}" id="editUsername${user.ID_De_Compte}">${user.Username}</td>
                    <td contenteditable="${contenteditable}" id="editEmail${user.ID_De_Compte}">${user.Email}</td>
                    <td contenteditable="${contenteditable}" id="editDate${user.ID_De_Compte}">${user.Date_D_Integration}</td>
                    <td>
                        <select id="editPerm${user.ID_De_Compte}">
                            <option value="administrateur" ${user.Permission === 'administrateur' ? 'selected' : ''}>Administrateur</option>
                            <option value="modérateur" ${user.Permission === 'modérateur' ? 'selected' : ''}>Modérateur</option>
                            <option value="compte standard" ${user.Permission === 'compte standard' ? 'selected' : ''}>Utilisateur Normal</option>
                        </select>
                    </td>
                    <td>
                        ${option ? `
                            <button type='button' onclick='saveUser(${user.ID_De_Compte})' class='no-style'>
                                <span class='material-symbols-rounded'>edit</span>
                            </button>
                            <button type='button' onclick='deleteUser(${user.ID_De_Compte})' class='no-style'>
                                <span class='material-symbols-rounded'>delete</span>
                            </button>
                        ` : ''}
                    </td>
                </tr>
            `;
                                    $('tbody').append(userRow);
                                });
                            }

                            if (input !== "") {
                                $.ajax({
                                    url: "script/api/api_acc.php",
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
                                        renderUsers(data.users);
                                    },
                                    error: function(xhr, status, error) {
                                        console.error("Erreur de recherche :", error);
                                        console.log("Réponse serveur :", xhr.responseText);
                                    }
                                });
                            } else {
                                $.ajax({
                                    url: "script/api/api_acc.php",
                                    method: "POST",
                                    data: {
                                        input: ""
                                    },
                                    dataType: "json",
                                    success: function(data) {
                                        if (data.error) {
                                            console.error(data.error);
                                            return;
                                        }
                                        renderUsers(data.users);
                                    },
                                    error: function(xhr, status, error) {
                                        console.error("Erreur de recherche :", error);
                                        console.log("Réponse serveur :", xhr.responseText);
                                    }
                                });
                            }
                        });
                        loadUsers(currentPage);
                    });

                    // Show/Hide form
                    let display = 0;
                    const table = document.querySelector('.t1');
                    const table2 = document.querySelector('.add');
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


                    function handleSubmit(event) {
                    event.preventDefault();

                    const form = event.target;
                    const formData = new FormData(form);

                    fetch(form.action, {
                        method: 'POST',
                        body: formData
                    })
                    .then(response => response.text()) 
                    .then(data => {
                        document.getElementById('message').innerText = 'Form submitted successfully!';
                        setTimeout(() => {
                        location.reload();
                        }, 1000);
                    })
                    .catch(error => {
                        document.getElementById('message').innerText = 'Error submitting form.';
                        console.error('Error:', error);
                    });
                    }
                    function changepass(userId) {
                        const newPassword = prompt("Entrez le nouveau mot de passe :");
                        if (newPassword) {
                            fetch('script/api/api_acc.php', {
                                    method: 'PUT',
                                    headers: {
                                        'Content-Type': 'application/json'
                                    },
                                    body: JSON.stringify({
                                        ID_De_Compte: userId,
                                        Password: newPassword
                                    })
                                })
                                .then(response => response.json())
                                .then(data => {
                                    if (data.error) {
                                        alert("Erreur : " + data.error);
                                    } else {
                                        alert("Mot de passe changé avec succès !");
                                    }
                                })
                                .catch(error => console.error("Erreur lors du changement de mot de passe :", error));
                        }
                    }

                </script>
</body>

</html>