<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Staistique</title>
  <link rel="stylesheet" href="css files/statistique.css">
  <link rel="shortcut icon" href="sinal-logo.ico" type="image/x-icon">
  <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Rounded:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200" />
</head>

<body>
<div class="container">
  <div class="left">
    <main>
      <img src="sinal-logo.ico" class="img" alt="Logo">
      <div class="logo">
        <button class="sidebar-close-btn" aria-label="Close Menu">&times;</button>
        <h2>IT TaskFlow</h2>
      </div>
      <nav>
        <ul>
          <li><a href="main.php"><span class="material-symbols-rounded">dashboard</span><span class="title">Dashboard</span></a></li>
          <li><a href="depense.php"><span class="material-symbols-rounded">task_alt</span><span class="title">Les Consommations</span></a></li>
          <li><a href="task.php"><span class="material-symbols-rounded">task</span><span class="title">Les Tâches</span></a></li>
          <li><a href="stk.php"><span class="material-symbols-rounded">inventory</span><span class="title">L'inventaire de Stock</span></a></li>
          <li><a href="Statistique.php"><span class="material-symbols-rounded">equalizer</span><span class="title">Les Statistiques</span></a></li>
          <li id="moderator-section" style="display: none;">
            <a href="comptes.php"><span class="material-symbols-rounded">manage_accounts</span><span class="title">Gestion des Comptes</span></a>
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
      <button class="menu-btn" aria-label="Open Menu">
        <span class="material-symbols-rounded">menu</span>
      </button>
      <div class="searchbk">
        <h2>Dashboard</h2>
        <div class="inputbk">
          <input type="text" placeholder="Recherche...">
        </div>
      </div>
      <div class="user">
        <div class="userImg">
          <img src="white_circle.png" alt="User Image">
        </div>
        <h2 id="username">Veuillez patienter...</h2>
        <h2 id="type">Veuillez patienter...</h2>
      </div>
    </div>

   <div class="stq-container">
  <div class="stq-task">
    <div class="stq-top">
      <h2>L'inventaire Global</h2>
      <h3 class="Date"></h3>
    </div>
    <canvas class="char"></canvas>
    <table id="global-summary" class="summary-table"></table>
  </div>
  <div class="stq-type">
    <div class="stqtime">
      <h2>L'inventaire IT</h2>
      <h3 class="current-Date"></h3>
    </div>
    <canvas class="chr"></canvas>
    <table id="it-summary" class="summary-table"></table>
  </div>
</div>
</div>

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
document.addEventListener('DOMContentLoaded', function () {
  const API_URL = 'script/stat/stat_task.php';
  let stockChartInstance = null;
  let itChartInstance = null;

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

  setupEventListeners();
  loadDashboard();

  function setupEventListeners() {
    document.querySelector('.menu-btn')?.addEventListener('click', () =>
      document.querySelector('.left')?.classList.toggle('active')
    );
    document.querySelector('.sidebar-close-btn')?.addEventListener('click', () =>
      document.querySelector('.left')?.classList.remove('active')
    );
  }

  async function loadDashboard() {
    try {
      const response = await fetch(API_URL);
      if (response.status === 401) {
        window.location.href = 'index.php';
        return;
      }
      if (!response.ok) throw new Error(`Erreur réseau: ${response.status}`);

      const apiResponse = await response.json();

      if (apiResponse.status === 'success') {
        const dashboardData = apiResponse.data;

        updateUserInfo(apiResponse.user);

        // Render charts and tables
        renderStockTypesChart(dashboardData.total_stock);
        renderStockTable('global-summary', dashboardData.total_stock);

        renderITStockChart(dashboardData.it_stock_total);
        renderStockTable('it-summary', dashboardData.it_stock_total);

        // Show total IT count
        const itTotal = Array.isArray(dashboardData.it_stock_total)
          ? dashboardData.it_stock_total.reduce((sum, item) => sum + item.count, 0)
          : 0;

        document.getElementById('it-stock-count')?.textContent === itTotal;

      } else {
        console.error('Erreur API:', apiResponse.message);
      }
    } catch (error) {
      console.error('Erreur fetch:', error);
    }
  }

  function updateUserInfo(user) {
    document.getElementById('username').textContent = user.nom || 'User';
    document.getElementById('type').textContent = user.permissions || 'Standard';
    $('#moderator-section').toggle(user.permissions === "administrateur" || user.permissions === "modérateur");
  }

  function renderStockTypesChart(stockArray) {
    const labels = stockArray.map(item => translations[item.type] || item.type);
    const data = stockArray.map(item => item.count);

    const baseColors = [
      '#FF6384', '#36A2EB', '#FFCE56', '#4BC0C0',
      '#9966FF', '#FF9F40', '#8E44AD', '#2ECC71',
      '#3498DB', '#E74C3C', '#F1C40F', '#1ABC9C'
    ];
    const backgroundColors = labels.map((_, i) => baseColors[i % baseColors.length]);

    const canvas = document.querySelector('.char');
    if (!canvas) return;

    stockChartInstance?.destroy();
    stockChartInstance = new Chart(canvas.getContext('2d'), {
      type: 'bar',
      data: {
        labels: labels,
        datasets: [{
          data: data,
          backgroundColor: backgroundColors,
          borderColor: '#fff',
          borderWidth: 1
        }]
      },
      options: {
        responsive: true,
        plugins: {
          legend: { display: false },
          title: {
            display: true,
            text: 'Répartition des Stocks par Type',
            color: '#333',
            font: { size: 16 }
          }
        }
      }
    });
  }

  function renderITStockChart(stockArray) {
    const labels = stockArray.map(item => translations[item.type] || item.type);
    const data = stockArray.map(item => item.count);

    // --- START: ADD THIS CODE ---
    // Define a list of colors to use
    const baseColors = [
        '#FF6384', '#36A2EB', '#FFCE56', '#4BC0C0',
        '#9966FF', '#FF9F40', '#8E44AD', '#2ECC71',
        '#3498DB', '#E74C3C', '#F1C40F', '#1ABC9C'
    ];
    // Create an array of colors, one for each bar
    const backgroundColors = labels.map((_, i) => baseColors[i % baseColors.length]);
    // --- END: ADD THIS CODE ---

    const canvas = document.querySelector('.chr');
    if (!canvas) return;

    itChartInstance?.destroy();
    itChartInstance = new Chart(canvas.getContext('2d'), {
        type: 'bar',
        data: {
            labels: labels,
            datasets: [{
                data: data,
                // --- CHANGE THIS LINE ---
                backgroundColor: backgroundColors, // Use the new colors array
                borderColor: '#fff',
                borderWidth: 1
            }]
        },
        options: {
        responsive: true,
        plugins: {
            legend: { display: false },
            title: {
                display: true,
                text: 'Détail des Stocks IT',
                color: '#333333', // CHANGE THIS to a dark color
                font: { size: 16 }
            }
        },
        scales: {
            y: {
                ticks: { color: '#666666' }, // CHANGE THIS to a dark color for Y-axis labels
                grid: { color: 'rgba(0, 0, 0, 0.1)' }
            },
            x: {
                ticks: { color: '#666666' }, // CHANGE THIS to a dark color for X-axis labels
                grid: { display: false } // Hiding vertical grid lines for a cleaner look
            }
        }
    }
});
}
  function renderStockTable(tableId, dataArray) {
    const table = document.getElementById(tableId);
    if (!table || !Array.isArray(dataArray)) return;

    table.innerHTML = `
      <thead>
        <tr><th>Type</th><th>Quantité</th></tr>
      </thead>
      <tbody>
        ${dataArray.map(item => `
          <tr>
            <td>${translations[item.type] || item.type}</td>
            <td>${item.count}</td>
          </tr>
        `).join('')}
      </tbody>
    `;
  }
});
  window.logOut = function () {
    window.location.href = "index.php";
  };
</script>
</body>
</html>
