<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <link rel="shortcut icon" href="sinal-logo.ico" type="image/x-icon">
  <title>Journal des Événements</title>
  <style>
    body {
      font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
      background-color: #f4f8fb;
      color: #333;
      margin: 0; /* Adjusted for full-page modal */
    }
    .container {
      max-width: 1200px;
      margin: 20px auto;
      background-color: #fff;
      padding: 25px;
      box-shadow: 0 2px 15px rgba(0,0,0,0.1);
      border-radius: 8px;
    }
    h1 {
      text-align: center;
      color: #22313f;
    }
    table {
      width: 100%;
      border-collapse: collapse;
      margin-top: 20px;
    }
    th, td {
      border: 1px solid #ccc;
      padding: 12px;
      text-align: left;
      vertical-align: middle;
    }
    th {
      background-color: #22313f;
      color: white;
      font-weight: 600;
    }
    tbody tr:nth-child(even) { background-color: #f9f9f9; }
    tbody tr:hover { background-color: #eef4f8; }
    .action-type {
      font-weight: bold;
      padding: 4px 8px;
      border-radius: 4px;
      color: white;
      text-align: center;
      display: inline-block;
      min-width: 80px;
      text-transform: uppercase;
      font-size: 0.9em;
    }
    .action-insert { background-color: #28a745; }
    .action-update { background-color: #007bff; }
    .action-delete { background-color: #dc3545; }
    .action-login  { background-color: #6c757d; }
    .pagination {
      text-align: center;
      margin-top: 25px;
    }
    .pagination a {
      color: #003366;
      padding: 8px 16px;
      text-decoration: none;
      border: 1px solid #ddd;
      margin: 0 4px;
      border-radius: 4px;
    }
    .pagination a.active {
      background-color: #003366;
      color: white;
      border-color: #003366;
    }
    .loading-shade {
      position: absolute; top: 0; left: 0; width: 100%; height: 100%;
      background: rgba(255, 255, 255, 0.75); display: flex;
      justify-content: center; align-items: center; z-index: 10;
    }

    /* --- Styles for Login Modal --- */
    #loginModal {
        position: fixed;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        background-color: rgba(0, 0, 0, 0.6);
        display: flex;
        justify-content: center;
        align-items: center;
        z-index: 1000;
    }
    .modal-content {
        background-color: white;
        padding: 40px;
        border-radius: 8px;
        box-shadow: 0 5px 20px rgba(0,0,0,0.2);
        width: 100%;
        max-width: 400px;
        text-align: center;
    }
    .modal-content h2 {
        margin-top: 0;
        color: #22313f;
    }
    .modal-content input[type="text"],
    .modal-content input[type="password"] {
        width: calc(100% - 20px);
        padding: 10px;
        margin-bottom: 15px;
        border: 1px solid #ccc;
        border-radius: 4px;
    }
    .modal-content button {
        width: 100%;
        padding: 12px;
        border: none;
        border-radius: 4px;
        background-color: #a78bfa;
        color: white;
        font-size: 16px;
        cursor: pointer;
        transition: background-color 0.3s;
    }
    .modal-content button:hover {
        background-color:rgb(135, 5, 187);
    }
    .error-message {
        color: #dc3545;
        margin-top: 15px;
        font-weight: bold;
        display: none;
    }

  </style>
</head>
<body>

<div id="loginModal">
  <div class="modal-content">
    <h2>Authentification requise</h2>
    <p>Veuillez vous connecter pour accéder au journal.</p>
    <form id="loginForm">
      <input type="text" id="username" name="username" placeholder="Nom d'utilisateur" required>
      <input type="password" id="password" name="password" placeholder="Mot de passe" required>
      <button type="submit">Connexion</button>
    </form>
    <div id="loginError" class="error-message"></div>
  </div>
</div>


<div class="container">
  <h1>Journal des Événements</h1>
  <div id="logTableContainer" style="position: relative;">
      <table>
        <thead>
          <tr>
            <th>Horodatage</th>
            <th>Utilisateur</th>
            <th>Action</th>
            <th>Table Affectée</th>
            <th>Détails</th>
          </tr>
        </thead>
        <tbody>
          </tbody>
      </table>
  </div>
  <div id="pagination" class="pagination"></div>
</div>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

<script>
  $(document).ready(function() {
    $('.container').hide();
    $('#loginForm').on('submit', function(e) {
      e.preventDefault();
      const username = $('#username').val();
      const password = $('#password').val();
      const $errorDiv = $('#loginError');
      $.ajax({
        url: 'script/api/api_login.php',
        type: 'POST',
        dataType: 'json',
        data: {
          username: username,
          password: password
        },
        success: function(response) {
          if (response.success && response.permissions === 'administrateur') {
            $('#loginModal').fadeOut();
            $('.container').show();
            loadLogs(1);
          } else {
            $errorDiv.text(response.message || 'Permissions insuffisantes.').show();
          }
        },
        error: function() {
          $errorDiv.text('Erreur de communication avec le serveur.').show();
        }
      });
    });


    function showLoading() {
      $('#logTableContainer').append('<div class="loading-shade">Chargement...</div>');
    }
    function hideLoading() {
      $('.loading-shade').remove();
    }

    function loadLogs(page = 1) {
      showLoading();
      $.ajax({
        url: 'script/api/api_evt.php',
        type: 'GET',
        dataType: 'json',
        data: { page: page },
        success: function(response) {
          const tableBody = $('tbody').empty();

          if (!response.logs || response.logs.length === 0) {
            tableBody.append('<tr><td colspan="6" style="text-align:center;">Aucun événement à afficher.</td></tr>');
            $('#pagination').empty();
            return;
          }

          response.logs.forEach(log => {
            const actionClass = 'action-' + (log.action_type || '').toLowerCase();
            const row = `
              <tr>
                <td>${log.action_time}</td>
                <td>${log.user_name}</td>
                <td><span class="action-type ${actionClass}">${log.action_type}</span></td>
                <td>${log.table_name}</td>
                <td>${log.log_details}</td>
              </tr>
            `;
            tableBody.append(row);
          });

          generatePagination(response.pagination);
        },
        error: function(xhr) {
          const errorMsg = xhr.responseJSON ? xhr.responseJSON.error : 'Impossible de contacter le serveur.';
          $('tbody').empty().append(`<tr><td colspan="6" style="text-align:center; color:red;">Erreur : ${errorMsg}</td></tr>`);
        },
        complete: function() {
          hideLoading();
        }
      });
    }

    function generatePagination(pagination) {
      const paginationDiv = $('#pagination').empty();
      if (!pagination || pagination.total_pages <= 1) return;

      if (pagination.page_actuelle > 1) {
        paginationDiv.append(`<a href="#" data-page="${pagination.page_actuelle - 1}">&laquo; Précédent</a>`);
      }
      for (let i = 1; i <= pagination.total_pages; i++) {
        paginationDiv.append(`<a href="#" class="${i === pagination.page_actuelle ? 'active' : ''}" data-page="${i}">${i}</a>`);
      }
      if (pagination.page_actuelle < pagination.total_pages) {
        paginationDiv.append(`<a href="#" data-page="${parseInt(pagination.page_actuelle) + 1}">Suivant &raquo;</a>`);
      }
    }

    $('#pagination').on('click', 'a', function(e) {
      e.preventDefault();
      loadLogs($(this).data('page'));
    });
    loadLogs(1); 
  });
</script>

</body>
</html>