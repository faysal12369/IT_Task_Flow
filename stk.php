<!DOCTYPE html>
<html lang="fr">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="css files/task1.css">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Rounded:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200" />
    <link rel="shortcut icon" href="sinal-logo.ico" type="image/x-icon">
    <title>L'inventaire De Stock</title>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://unpkg.com/bwip-js/dist/bwip-js-min.js"></script>
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
                        <li id="moderator-section" style="display: none;">
                            <a href="sim.php"><span class="material-symbols-rounded">sim_card</span><span class="title">La Float</span></a>
                        </li>
                        <li><a href="Statistique.php"><span class="material-symbols-rounded">equalizer</span><span class="title">Les Statistiques</span></a></li>
                        <li id="admin-section" style="display: none;">
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

        <div class="right">
            <div class="top">
                <button class="menu-btn">
                    <span class="material-symbols-rounded">menu</span>
                </button>
                <div class="searchbk">
                    <h2>Tableau D'inventaire</h2>
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
                <button type="button" class="add_tac" onclick="show()">Ajouter L'équipement</button>
                <table class="t1" id="t1">
                    <thead>
                        <tr>
                            <th>Equipement</th>
                            <th>Model D'Equipement</th>
                            <th>Division</th>
                            <th>Service</th>
                            <th>Utilisateur</th>
                            <th>étage</th>
                            <th>Numéro De Série</th>
                            <th>Statut De L'équipement</th>
                            <th id="permission-section" style="display: none;">Option</th>
                        </tr>
                    </thead>
                    <tbody></tbody>
                </table>
                <div class="add_tach" style="display: none;">
                <form action="script/api/api_stk.php" method="POST" onsubmit="handleSubmit(event)">
                <input type="hidden" name="ajouter_stk" value="1">

                <div class="table01">
        <h2>Ajouter un matériel</h2>
        <input type="text" name="equip" placeholder="Nom de l'équipement" required>
        
        <select name="type" required>
            <option value="">-- Type d'équipement --</option>
            <option value="adapter">Adaptateur</option>
            <option value="laptop">Ordinateur Portable</option>
            <option value="central unit">Unité Central</option>
            <option value="monitor">Écran</option>
            <option value="storage bay">Baie De Stockage</option>
            <option value="printer">Imprimante</option>
            <option value="toner cartridge">Toner de l'imprimante</option>
            <option value="Cleaning kit">Kit de nettoyage</option>
            <option value="Ribbon">Ruban</option>
            <option value="scanner">Scanner</option>
            <option value="landline phone">Téléphone Fix</option>
            <option value="Fax">Fax</option>
            <option value="mobile phone">Téléphone Mobile</option>
            <option value="ups">Onduleur</option>
            <option value="router">Routeur</option>
            <option value="switch">Switch</option>
            <option value="server">Serveur</option>
            <option value="external hard drive">Disque Dur Externe</option>
            <option value="usb drive">Clé USB</option>
            <option value="projector">Projecteur</option>
            <option value="modem">Modem</option>
            <option value="wi-fi access point">Point d'accès Wi-Fi</option>
            <option value="surveillance camera">Caméra de surveillance</option>
            <option value="patch panel">Baie de brassage</option>
        </select>

        <select name="division" required>
            <option value="">-- Division --</option>
            <option value="DG">DG</option>
            <option value="DS">DS</option>
            <option value="Victoria">Victoria</option>
            <option value="Optique">Optique</option>
            <option value="Acuitis">Acuitis</option>
            <option value="Biotug">Biotug</option>
            <option value="Khm">Agence Khmissti</option>
            <option value="tiz">Agence Tizi</option>
            <option value="stf">Agence Sétif</option>
            <option value="alg">Agence Alger</option>
            <option value="bej">Agence Béjaia</option>
        </select>

        <input type="text" name="user" placeholder="Responsable du stock" required>
        <input type="text" name="designation" placeholder="Désignateur du bureau de stock" required>
        <input type="text" name="bureau" placeholder="Bureau de stock" required>
        <select name="floor" required>
            <option value="">-- étage --</option>
            <option value="0">Rez-de-chaussée</option>
            <option value="1">1er étage</option>
            <option value="2">2ème étage</option>
            <option value="3">3ème étage</option>
            <option value="4">4ème étage</option>
        </select>

        <input type="text" name="ref" placeholder="Référence de l'équipement" >

       <select select name="statut" required>
            <option value="good condition">L'équipement est en bon état</option>
            <option value="defective">L'équipement est Défectueux</option>
        </select>

        <input type="hidden" name="ajouter_dep" value="1">
        <button type="submit" class="add_tac">Ajouter</button>

        <button type="button" class="ext" onclick="exit()">Fermer </button>
        <p id="message"></p>
    </div>
</form>
</div>
<div id="pagination" class="pag"></div>
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
    function formatEtage(floor) {
    if (floor === 0 || floor === "0") return 'Rez-de-chaussée';
    if (floor === 1 || floor === "1") return '1er étage';
    if (floor === 2 || floor === "2") return '2ème étage';
    if (floor === 3 || floor === "3") return '3ème étage';
    if (floor === 4 || floor === "4") return '4ème étage';
    if (floor === 5 || floor === "5") return '5ème étage';
    if (floor === 6 || floor === "6") return '6ème étage';
    if (floor === 7 || floor === "7") return '7ème étage';
    if (floor === 8 || floor === "8") return '8ème étage';
    if (floor === 9 || floor === "9") return '9ème étage';
    if (floor === 10 || floor === "10") return '10ème étage';

    return `${floor}e étage`;
}
function translation(type) {
    if (type ==='Adapter' || type==='adapter') return 'Adaptateur';
    if (type ==='laptop' || type==='Laptop') return 'Ordinateur Portable';
    if (type ==='Central Unit' || type==='central unit') return 'Unité Central';
    if (type ==='Monitor' || type==='monitor') return 'Écran';
    if (type ==='Storage Bay' || type==='storage bay') return 'Baie De Stockage';
    if (type ==='Printer' || type==='printer') return 'Imprimante';
    if (type ==='printer cartridge set' || type==='Printer Cartridge Set') return 'Jeu De Cartouche';
    if (type ==='Printer' || type==='printer') return 'Imprimante';
    if (type ==='Cleaning kit' || type==='cleaning kit') return 'Kit de nettoyage';
    if (type ==='printer toner'|| type==='Printer Toner') return "Toner de l'imprimante" ;
    if (type ==='printer toner blue' || type==='Printer Toner Blue') return "Toner de l'imprimante Bleu" ;
    if (type ==='printer toner jaune' || type==='Printer Toner Jaune') return "Toner de l'imprimante Jaune" ;
    if (type ==='printer toner magenta' || type==='Printer Toner Magenta') return "Toner de l'imprimante Magenta" ;
    if (type ==='printer toner noir' || type==='Printer Toner Noir') return "Toner de l'imprimante Noir" ;
    if (type ==='Ribbon' || type==='ribbon') return 'Ruban';
    if (type ==='Landline Phone' || type==='landline phone') return 'Téléphone Fix';
    if (type ==='Mobile Phone' || type==='mobile phone') return 'Téléphone Mobile';
    if (type ==='UPS' || type==='ups') return 'Onduleur';
    if (type ==='Router' || type==='router') return 'Rooter';
    if (type ==='External Hard Drive' || type==='external hard drive') return 'Disque Dur Externe';
    if (type ==='USB Drive"' || type==='usb drive') return 'Clé USB';
    if (type ==='Projector' || type==='projector') return 'Projecteur';
    if (type ==='Wi-Fi Access Point' || type==='wi-fi access point') return "Point d'accès Wi-Fi";
    if (type ==='Surveillance Camera' || type==='surveillance camera') return 'Caméra de surveillance';
    if (type ==='Patch Panel' || type==='patch panel') return 'Baie de brassage<';
    return `${type}`;
}
    function formatdesigntion(designation) {
        if (designation === "SDM") return 'Service De Marché';
        if (designation === "DS") return 'Division Scientifique';
        return designation;
    }
       $(document).ready(function() {
    let currentPage = 1;
    const itemPerPage = 12;
    function formatref(ref) {
        if (ref==="PNS") return 'Pas de Numéro de Série';
        return ref;
    }
    function loadstk(page) {
        console.log(`Loading stock for page: ${page}`);

        $.ajax({
            url: 'script/api/api_stk.php',
            dataType: 'json',
            data: {
                page: page,
                limit: itemPerPage
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

                if (data.permissions === 'administrateur' || data.permissions === 'modérateur') {
                    $('#permission-section').show();
                    $('#admin-section').show();
                }

                const taskTable = $('tbody');
                taskTable.empty();

                data.stock.forEach(stock => {
                    const isEditable = (data.permissions === "modérateur" || data.permissions === "administrateur");

                    const taskRow = `
                        <tr class="${stock.class === 'urgent_container' ? 'urgent' : ''}">
                            <td contenteditable="${isEditable}" id="editEquip${stock.id}">${translation(stock.type)}</td>
                            <td contenteditable="${isEditable}" id="editType${stock.id}">${stock.equip}</td>
                            <td>
                                ${isEditable ? `
                                    <select id="editDiv${stock.id}">
                                        <option value="DG" ${stock.division === 'DG' ? 'selected' : ''}>DG</option>
                                        <option value="Batinorm" ${stock.division === 'Batinorm' ? 'selected' : ''}>Batinorm</option>
                                        <option value="DS" ${stock.division === 'DS' ? 'selected' : ''}>DS</option>
                                        <option value="Victoria" ${stock.division === 'Victoria' ? 'selected' : ''}>Victoria</option>
                                        <option value="Optique" ${stock.division === 'Optique' ? 'selected' : ''}>Optique</option>
                                        <option value="Acuitis" ${stock.division === 'Acuitis' ? 'selected' : ''}>Acuitis</option>
                                        <option value="Biotug" ${stock.division === 'Biotug' ? 'selected' : ''}>Biotug</option>
                                        <option value="khm" ${stock.division === 'khm' ? 'selected' : ''}>Agence Khmisti</option>
                                        <option value="tiz" ${stock.division === 'tiz' ? 'selected' : ''}>Agence Tizi-Ouzo</option>
                                        <option value="stf" ${stock.division === 'stf' ? 'selected' : ''}>Agence Sétif</option>
                                        <option value="alg" ${stock.division === 'alg' ? 'selected' : ''}>Agence Alger</option>
                                        <option value="bej" ${stock.division === 'bej' ? 'selected' : ''}>Agence Béjaia</option>
                                    </select>
                                ` : `
                                    <span id="editDiv${stock.id}">
                                        ${
                                            {
                                                'DG': 'DG',
                                                'DS': 'DS',
                                                'Victoria': 'Victoria',
                                                'Optique': 'Optique',
                                                'Acuitis': 'Acuitis',
                                                'Biotug': 'Biotug',
                                                'khm': 'Agence Khmisti',
                                                'tiz': 'Agence Tizi-Ouzo',
                                                'stf': 'Agence Sétif',
                                                'alg': 'Agence Alger',
                                                'bej': 'Agence Béjaia'
                                            }[stock.division] || stock.division
                                        }
                                    </span>
                                `}
                            </td>
                            <td contenteditable="${isEditable}" id="editDesignation${stock.id}">${formatdesigntion(stock.designation)}</td>
                            <td contenteditable="${isEditable}" id="editUser${stock.id}">${stock.user}</td>
                            <td contenteditable="${isEditable}" id="editFloor${stock.id}">${formatEtage(stock.floor)}</td>
                            <td contenteditable="${isEditable}" id="editRef${stock.id}">${formatref(stock.ref)}</td>
                            <td>
                                ${isEditable ? `
                                    <select id="editStat${stock.id}">
                                        <option value="bon état" ${stock.statut === 'bon état' ? 'selected' : ''}>L'équipement est en bon état</option>
                                        <option value="Marche Pas" ${stock.statut === 'Marche Pas' ? 'selected' : ''}>L'équipement est Défectueux</option>
                                    </select>
                                ` : `
                                    <span id="editStat${stock.id}">
                                        ${
                                            {
                                                'bon état': `L'équipement est en bon état`,
                                                'Marche Pas': `L'équipement est Défectueux`
                                            }[stock.statut] || stock.statut
                                        }
                                    </span>
                                `}
                            </td>
                            ${isEditable ? `
                                <td>
                                    <button type="button" onclick="saveChanges(${stock.id})" class="action-btn edit-btn">
                                        <span class="material-symbols-rounded">edit</span>
                                    </button>
                                    <button type="button" onclick="DeleteChanges(${stock.id})" class="action-btn delete-btn">
                                        <span class="material-symbols-rounded">delete</span>
                                    </button>
                                     <button type="button" onclick="printChanges(${stock.id})" class="action-btn  print-btn">
                                        <span class="material-symbols-rounded">print</span>
                                    </button>
                                     <button type="button" onclick="history(${stock.id})" class="action-btn  history-btn">
                                        <span class="material-symbols-rounded">history</span>
                                    </button>
                                </td>
                            ` : ``}
                        </tr>
                    `;

                    taskTable.append(taskRow);
                });

                generatePagination(data.pagination.current_page, data.pagination.total_pages);
            },
            error: function(xhr, status, error) {
                console.error("AJAX Error:", error);
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

                $('#pagination a').click(function(event) {
                    event.preventDefault();
                    const page = parseInt($(this).data('page'));
                    loadstk(page);
                });
    }
    loadstk(currentPage);
});
function saveChanges(stockId) {
    const updatedStock = {
        id: stockId,
        division: document.getElementById(`editDiv${stockId}`).value,
        designation: document.getElementById(`editDesignation${stockId}`).innerText,
        user: document.getElementById(`editUser${stockId}`).innerText,
        floor: document.getElementById(`editFloor${stockId}`).innerText,
        ref: document.getElementById(`editRef${stockId}`).innerText,
        equip: document.getElementById(`editEquip${stockId}`).innerText,
        statut: document.getElementById(`editStat${stockId}`).value,
        type: document.getElementById(`editType${stockId}`).innerText||value
    };
    fetch('script/api/api_stk.php', {
        method: 'PUT',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(updatedStock)
    })
    .then(response => response.json())
    .then(data => {
        alert(data.error ? "Erreur : " + data.error : "Stock mis à jour avec succès !");
        loadstk(1);
    })
    .catch(error => console.error("Erreur lors de la mise à jour :", error));
}

function DeleteChanges(stockId) {
    if (confirm("Êtes-vous sûr de vouloir supprimer cet équipement ?")) {
        fetch('script/api/api_stk.php', {
            method: 'DELETE',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ id: stockId })
        })
        .then(response => response.json())
        .then(data => {
            alert(data.error ? "Erreur : " + data.error : "Stock supprimé avec succès !");
            loadstk(1);
        })
        .catch(error => console.error("Erreur lors de la suppression :", error));
        
    }
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
            url: "script/api/api_stk.php",
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
                renderStock(data.stock, data.pagination);
            },
            error: function(xhr, status, error) {
                console.error("Search error:", error);
            }
        });
    }

    function formatEtage(floor) {
    if (floor === 0 || floor === "0") return 'Rez-de-chaussée';
    if (floor === 1 || floor === "1") return '1er étage';
    if (floor === 2 || floor === "2") return '2ème étage';
    if (floor === 3 || floor === "3") return '3ème étage';
    if (floor === 4 || floor === "4") return '4ème étage';
    if (floor === 5 || floor === "5") return '5ème étage';
    if (floor === 6 || floor === "6") return '6ème étage';
    if (floor === 7 || floor === "7") return '7ème étage';
    if (floor === 8 || floor === "8") return '8ème étage';
    if (floor === 9 || floor === "9") return '9ème étage';
    if (floor === 10 || floor === "10") return '10ème étage';
    return `${floor}e étage`;
}

function formatdesigntion(designation) {
    if (designation === "SDM") return 'Service De Marché';
    if (designation === "DS") return 'Division Scientifique';
    return designation;
}
    function renderStock(stock, pagination) {
        $('tbody').empty();
        stock.forEach(stock => {
            const contenteditable = ($('#type').text() === "modérateur" || $('#type').text() === "administrateur") ? "true" : "false";
            const option = (contenteditable === "true");
            const stockRow = `
                <tr class="${stock.class === 'urgent_container' ? 'urgent' : ''}">
                    <td contenteditable="${contenteditable}" id="editEquip${stock.id}">${translation(stock.type)}</td>
                    <td contenteditable="${contenteditable}" id="editType${stock.id}">${stock.equip}</td>
                    <td>
                        ${option ? `
                            <select id="editdiv${stock.id}">
                                <option value="DG" ${stock.division === 'DG' ? 'selected' : ''}>DG</option>
                                <option value="Batinorm" ${stock.division === 'Batinorm' ? 'selected' : ''}>Batinorm</option>
                                <option value="DS" ${stock.division === 'DS' ? 'selected' : ''}>DS</option>
                                <option value="Optique" ${stock.division === 'Optique' ? 'selected' : ''}>Optique</option>
                                <option value="Acuitis" ${stock.division === 'Acuitis' ? 'selected' : ''}>Acuitis</option>
                                <option value="Biotug" ${stock.division === 'Biotug' ? 'selected' : ''}>Biotug</option>
                                <option value="khm" ${stock.division === 'khm' ? 'selected' : ''}>Agence Khmisti</option>
                                <option value="tiz" ${stock.division === 'tiz' ? 'selected' : ''}>Agence Tizi-Ouzo</option>
                                <option value="stf" ${stock.division === 'stf' ? 'selected' : ''}>Agence Sétif</option>
                                <option value="alg" ${stock.division === 'alg' ? 'selected' : ''}>Agence Alger</option>
                                <option value="bej" ${stock.division === 'bej' ? 'selected' : ''}>Agence Béjaia</option>
                            </select>
                        ` : `
                            <span id="editdiv${stock.id}">
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
                                }[stock.division] || stock.division}
                            </span>
                        `}
                    </td>
                    <td contenteditable="${contenteditable}" id="editdesignation${stock.id}">${formatdesigntion(stock.designation)}</td>
                    <td contenteditable="${contenteditable}" id="edituser${stock.id}">${stock.user}</td>
                    <td contenteditable="${contenteditable}" id="editfloor${stock.id}">${formatEtage(stock.floor)}</td>
                    <td contenteditable="${contenteditable}" id="editref${stock.id}">${(stock.ref)}</td>
                    <td>
                                  ${option ? `
                                    <select id="editStat${stock.id}">
                                        <option value="Bon état" ${stock.statut === 'Bon état' ? 'selected' : ''}>L'équipement est en bon état</option>
                                        <option value="Marche Pas" ${stock.statut === 'Marche Pas' ? 'selected' : ''}>L'équipement est Défectueux</option>
                                    </select>
                                ` : `
                                    <span id="editStat${stock.id}">
                                        ${
                                            {
                                                'Bon état': `L'équipement est en bon état`,
                                                'Marche Pas': `L'équipement est Défectueux`
                                            }[stock.statut] || stock.statut
                                        }
                                    </span>
                                `}
                            </td>
                        ${option ? `
                        <td>
                            <button type="button" onclick="saveChanges(${stock.id})" class="action-btn edit-btn">
                                <span class="material-symbols-rounded">edit</span>
                            </button>
                            <button type="button" onclick="DeleteChanges(${stock.id})" class="action-btn delete-btn">
                                <span class="material-symbols-rounded">delete</span>
                            </button>
                              <button type="button" onclick="printChanges(${stock.id})" class="action-btn  print-btn">
                                        <span class="material-symbols-rounded">print</span>
                                    </button>
                                     <button type="button" onclick="history(${stock.id})" class="action-btn  history-btn">
                                        <span class="material-symbols-rounded">history</span>
                                    </button>
                        ` : ``}
                </tr>
            `;
            $('tbody').append(stockRow);
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
            url: "script/api/api_stk.php",
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
                renderStock(data.stock, data.pagination);
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
    console.log("Formulaire soumis");

    const form = event.target;
    const formData = new FormData(form);

    fetch(form.action, {
        method: 'POST',
        body: formData
    })
    .then(response => response.text())
    .then(data => {
        console.log('Response:', data);
        document.getElementById('message').innerText = 'Dépense Ajoutée Avec Succès !';
    })
    .catch(error => {
        console.log('Error:', error);
        document.getElementById('message').innerText = `Erreur lors de l'ajout de la dépense.`;
    });
}

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
          function logOut() {
            window.location.href = "index.php";
        }

function printChanges(id) {
  const barcodeValue = document.getElementById("editRef" + id)?.innerText;

  if (!barcodeValue) {
    alert("Barcode value is empty or invalid.");
    return;
  }

  const parts = barcodeValue.split(/\s+au\s+/i);
  const labelTextBottom = parts.length === 2 ? `${parts[0]} au ${parts[1]}` : barcodeValue;
  const encodedValue = parts.length === 2 ? parts[0] : barcodeValue.replace(/\s+/g, '');
  const labelTextTop = "Service Informatique";

  const printWindow = window.open('', '', 'width=200,height=200');

  const html =
    '<html>' +
      '<head>' +
        '<title>Print Barcode</title>' +
        '<script src="https://unpkg.com/bwip-js/dist/bwip-js-min.js"></scr' + 'ipt>' +
        '<style>' +
          'body { margin: 0; padding: 0; font-family: Arial, sans-serif; }' +
          '.label-container { width: 100%; box-sizing: border-box; padding: 4px; }' +
          '.label-header {' +
            'display: flex;' +
            'justify-content: space-between;' +
            'align-items: flex-start;' +
            'font-weight: bold;' +
            'font-size: 10px;' +
          '}' +
          '.sinal-box {' +
            'border: 1px solid black;' +
            'padding: 1px 4px;' +
            'font-size: 10px;' +
          '}' +
          '.label-title-bottom { font-size: 10px; margin: 6px 0 4px; font-weight: bold; text-align: center; }' +
          'canvas { display: block; margin: auto; width: 90%; height: auto; }' +
          '@media print {' +
            '@page { size: 50mm 25mm; margin: 0; }' +
            'html, body {' +
              'margin: 0;' +
              'padding: 0;' +
              'width: 50mm;' +
              'height: 25mm;' +
              'overflow: hidden;' +
            '}' +
          '}' +
        '</style>' +
      '</head>' +
      '<body>' +
        '<div class="label-container">' +
          '<div class="label-header">' +
            '<div>' + labelTextTop + '</div>' +
            '<div class="sinal-box">SINAL</div>' +
          '</div>' +
          '<div class="label-title-bottom">' + labelTextBottom + '</div>' +
          '<canvas id="barcodeCanvas"></canvas>' +
        '</div>' +
        '<script>' +
          'window.onload = function() {' +
            'bwipjs.toCanvas("barcodeCanvas", {' +
              'bcid: "code128",' +
              'text: "' + encodedValue + '",' +
              'scale: 4,' +
              'height: 40,' +
              'includetext: false,' +
              'textxalign: "center"' +
            '});' +
            'setTimeout(function() {' +
              'window.print();' +
              'setTimeout(function() { window.close(); }, 100);' +
            '}, 500);' +
          '};' +
        '</scr' + 'ipt>' +
      '</body>' +
    '</html>';
  printWindow.document.open();
  printWindow.document.write(html);
  printWindow.document.close();
}



function history(id) {
  console.log("showHistory got ID:", id);
  if (!id) {
    alert("Aucun ID fourni pour l’historique.");
    return;
  }
  window.open(
    `history.php?id=${encodeURIComponent(id)}`,
    "_blank",
    "width=800,height=600"
  );
}
</script>
    </body>
</html>