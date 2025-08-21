<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Feuille de Suivi D'équipement IT</title>
  <style>
    body {
      font-family: Arial, sans-serif;
      background-color: #f4f8fb;
      margin: 0;
      padding: 0;
    }
    .container {
      width: 90%;
      margin: 20px auto;
      background-color: #fff;
      padding: 20px;
      box-shadow: 0 0 10px rgba(0,0,0,0.1);
    }
    h1 {
      text-align: center;
      color: #34495e;
    }
    table {
      width: 100%;
      border-collapse: collapse;
      margin-bottom: 30px;
    }
    th, td {
      border: 1px solid #ccc;
      padding: 8px;
      text-align: center;
    }
    th {
      background-color: rgb(4, 103, 128);
      color: white;
    }
    .stk-title {
      background-color:rgb(0, 120, 156);
      color: white;
      padding: 10px;
      margin-top: 30px;
      font-size: 1.2em;
      text-align: center;
    }
    .pag {
        text-align: center;
        margin-top: 20px;
    }
    .pag a {
        color: #34495e;
        padding: 8px 16px;
        text-decoration: none;
        border: 1px solid #ddd;
        margin: 0 4px;
        transition: background-color .3s;
    }
    .pag a.active {
        background-color:rgb(12, 81, 150);
        color: white;
        border: 1px solid #34495e;
    }
    .pag a:hover:not(.active) {
        background-color: #f2f2f2;
    }
  </style>
</head>
<body>
  <div class="container">
    <h1>Feuille de Suivi D'équipement IT</h1>

    <div class="stk-title"></div>
    <table>
      <thead>
        <tr>
            <th>Numéro de suivi</th>
            <th>Date De Mouvement</th>
            <th>Numéro De Série</th>
            <th>Division</th>
            <th>Etage</th>
            <th>Bureau</th>
            <th>Responsable</th>
            <th id="th-movement-type">Type de Mouvement</th>
            <th id="th-toner-counter" style="display: none;">Compteur De L'imprimante</th>
        </tr>
      </thead>
      <tbody>
        </tbody>
    </table>
    <div id="pagination" class="pag"></div>
  </div>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
  const params = new URLSearchParams(window.location.search);
  const stockId = params.get('id');
  if (!stockId) {
    $('body').html('<p style="color:red;text-align:center;">Erreur : aucun ID de stock fourni.</p>');
    throw new Error("ID de stock manquant");
  }

  let currentPage = 1;
  const itemPerPage = 12;

function translation(name) {
    if (!name) return '';
    let translatedName = name;

    const translations = {
        'printer toner blue': "Toner de l'imprimante Bleu",
        'printer toner jaune': "Toner de l'imprimante Jaune",
        'printer toner magenta': "Toner de l'imprimante Magenta",
        'printer toner noir': "Toner de l'imprimante Noir",
        'printer toner': "Toner de l'imprimante",
        'central unit': 'Unité Centrale',
        'storage bay': 'Baie De Stockage',
        'cleaning kit': 'Kit de nettoyage',
        'landline phone': 'Téléphone Fixe',
        'mobile phone': 'Téléphone Mobile',
        'external hard drive': 'Disque Dur Externe',
        'usb drive': 'Clé USB',
        'wi-fi access point': "Point d'accès Wi-Fi",
        'surveillance camera': 'Caméra de surveillance',
        'patch panel': 'Baie de brassage',
        'adapter': 'Adaptateur',
        'laptop': 'Ordinateur Portable',
        'monitor': 'Écran',
        'printer cartridge set': "Jeu De Cartouches",
        'printer': 'Imprimante',
        'ribbon': 'Ruban',
        'ups': 'Onduleur',
        'router': 'Routeur',
        'projector': 'Projecteur'
    };

    for (const key in translations) {
        const regex = new RegExp(key, 'i');
        if (translatedName.match(regex)) {
            translatedName = translatedName.replace(regex, translations[key]);
        }
    }
    return translatedName;
}
  function formatEtage(floor) {
    if (floor === 0 || floor === "0") return 'Rez-de-chaussée';
    if (floor === 1 || floor === "1") return '1er étage';
    return `${floor}ème étage`;
  }

  function formatMouvement(movementType) {
    const type = (movementType || '').toLowerCase();
    switch(type) {
        case "in": return 'Entrée';
        case "out": return 'Sortie';
        case "initial addition": return 'Ajout Initial';
        default: return movementType;
    }
  }

  function loadstk(page) {
    $.ajax({
      url: 'script/api/api_trk.php',
      dataType: 'json',
      data: { id: stockId, page: page, limit: itemPerPage },
      xhrFields: { withCredentials: true },
      success: function(data) {
        if (data.error) {
          alert(data.error);
          return;
        }

        const $titleDiv = $('.stk-title').empty();
        const taskTable = $('tbody').empty();
        const rows = data.tracking || [];

        if (rows.length > 0) {
          const equipmentName = translation(rows[0].name);
          $titleDiv.text(`Historique pour : ${equipmentName}`);
          
          // Check if the equipment is a toner
          const isToner = equipmentName.toLowerCase().startsWith("toner de l'imprimante");

          // Toggle table headers based on the equipment type
          if (isToner) {
            $('#th-movement-type').hide();
            $('#th-toner-counter').show();
          } else {
            $('#th-movement-type').show();
            $('#th-toner-counter').hide();
          }
          
          rows.forEach(track => {
            const isTonerRow = translation(track.name).toLowerCase().startsWith("toner de l'imprimante");
            
            // Determine the content of the last cell
            const lastCell = isTonerRow 
              ? `<td>${track.toner_counter || 'N/A'}</td>`
              : `<td>${formatMouvement(track.movement_type)}</td>`;

            const row = `
              <tr>
                <td>${track.code_stk}</td>
                <td>${track.movement_date}</td>
                <td>${track.ref}</td>
                <td>${track.division}</td>
                <td>${formatEtage(track.floor)}</td>
                <td>${track.bureau}</td>
                <td>${track.responsable}</td>
                ${lastCell}
              </tr>`;
            taskTable.append(row);
          });

        } else {
          $titleDiv.text("Historique vide pour cet équipement");
        }

        generatePagination(data.pagination.current_page, data.pagination.total_pages);
      },
      error: function(xhr, status, error) {
        console.error("Erreur AJAX:", error);
        $('.container').html('<p style="color:red;text-align:center;">Erreur lors du chargement des données de suivi.</p>');
      }
    });
  }

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

    // Use .on() for event delegation, which is more robust
    paginationDiv.on('click', 'a', function(e) {
      e.preventDefault();
      loadstk(parseInt($(this).data('page')));
    });
  }

  $(document).ready(() => {
    loadstk(currentPage);
  });
</script>
</body>
</html>