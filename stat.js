// first date
const t = new Date();
let text = t.toLocaleDateString();
document.querySelector('.Date').innerHTML = text;

// second date
document.querySelector('.current-Date').innerHTML = text;

// Adding 7 days to the Date
t.setDate(t.getDate() + 7);
let tx = t.toLocaleDateString();
document.querySelector('.inc-Date').innerHTML = tx;



// chart js
const ct = document.querySelector('.char');
fetch("script1.php")
.then((response) =>  {
  return response.json();
})
.then((data) => {
  console.log(data);
  createchart1(data, 'line');
});
function createchart1(chartData,type){
  const monthCounts = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
  chartData.forEach(row => {
    const month = new Date(row.start_date).getMonth();
    monthCounts[month] += 1;
  });
new Chart(ct, {
  type: type,
  data: {
    labels: ['Jan', 'Fév', 'Mars', 'Avril', 'Mai', 'Juin', 'Juillet', 'Aout', 'Sep', 'Octo', 'Nov', 'Dec'],
    datasets: [
      {
        label: 'DG',
        data: chartData.map(row => row.id),
        borderColor: 'rgba(75, 192, 192, 1)',
        borderWidth: 3,
        fill: false  
      },
      {
        label: 'DS',
        data: [3, 8, 13, 18, 23, 28, 33, 38, 48, 43, 53, 58],
        borderColor: 'rgba(255, 99, 132, 1)',
        borderWidth: 3,
        fill: false
      },
      {
        label: 'Optique',
        data: [5, 10, 15, 10, 25, 30, 35, 40, 55, 45, 50, 60],
        borderColor: 'rgb(55, 74, 167)',
        borderWidth: 3,
        fill: false  
      },
      {
        label: 'Acuitis',
        data: [5, 10, 15, 15, 25, 30, 35, 40, 55, 45, 50, 60],
        borderColor: 'rgba(6, 188, 188, 0.83)',
        borderWidth: 3,
        fill: false  
      },
      {
        label: 'Sinal',
        data: [5, 10, 15, 17, 25, 30, 35, 40, 55, 45, 50, 60],
        borderColor: 'rgb(117, 22, 99)',
        borderWidth: 3,
        fill: false  
      },
      {
        label: 'Victoria',
        data: [5, 10, 15, 23, 25, 30, 35, 40, 55, 45, 50, 60],
        borderColor: 'rgb(207, 252, 6)',
        borderWidth: 3,
        fill: false  
      },
      {
        label: 'Biotug',
        data: [5, 10, 15, 26, 25, 30, 35, 40, 55, 45, 50, 60],
        borderColor: 'rgb(46, 31, 132)',
        borderWidth: 3,
        fill: false  
      },
      {
        label: 'Dispomed',
        data: [5, 10, 15, 30, 25, 30, 35, 40, 55, 45, 50, 60],
        borderColor: 'rgb(13, 75, 75)',
        borderWidth: 3,
        fill: false
      },
    ]
  },
  options: {
    responsive: true,
    maintainAspectRatio: false,
    scales: {
      x: {
        beginAtZero: true
      },
      y: {
        beginAtZero: true,
        title: {
          display: true,
          text: "Nombre de Taches",
          weight:'bold'
        }
      }
    },
    categoryPercentage: 0.7,
    plugins: {
      title: {
        display: true,
        text: 'Graphique des Tâches', 
        font: {
          size: 20,
          weight: 'bold', 
        },
        padding: {
          top: 20, 
        }
      }
    }
  }
});
}
// circle chart
const c = document.querySelector('.chr');
new Chart(c, {
  type: 'pie',
  data: {
    labels: ['Tache De Pc', 'Tache De Réseau',],
    datasets: [{
      label: 'Type De Taches',
      data: [400,500],
      backgroundColor: [
        'rgb(255, 99, 132)',
        'rgb(54, 162, 235)',
      ],
      hoverOffset: 3
    }]
  },
  options: {
    responsive: true,
    maintainAspectRatio: false,
    plugins: {
      title: {
        display: true,
        text: 'Type De Tache',
        font: {
          size: 20,
          weight: 'bold'
        },
        padding: {
          top: 20
        }
      }
    }
  }
});
// third chart
const ctr = document.querySelector('.prsn');
new Chart(ctr, {
  type: 'bar',
  data: {
    labels: ['Jan', 'Fév', 'Mars', 'Avril', 'Mai', 'Juin', 'Juillet', 'Aout', 'Sep', 'Octo', 'Nov', 'Dec'],
    datasets: [
      {
        label: 'DG',
        data: [5, 10, 15, 20, 25, 30, 35, 40, 55, 45, 50, 60],
        borderColor: 'rgba(75, 192, 192, 1)',
        borderWidth: 3,
        fill: false  
      }
    ]
  },
  options: {
    responsive: true,
    maintainAspectRatio: false,
    scales: {
      x: {
        beginAtZero: true
      },
      y: {
        beginAtZero: true,
        title: {
          display: true,
          text: "Nombre de Taches",
          weight: 'bold'
        }
      }
    },
    categoryPercentage: 0.7,
    plugins: {
      title: {
        display: true,
        text: 'Graphique des Tâches',  // Title for the third chart
        font: {
          size: 20,
          weight: 'bold', 
        },
        padding: {
          top: 20, 
        }
      }
    }
  }
});











// const mysql = require('mysql2');

// const pool = mysql.createPool({
//   host: 'localhost',
//   user: 'root',
//   password: 'password',
//   database: 'test_db',
//   connectionLimit: 10
// });

// // SQL statement to create a new table
// const createTableQuery = `
//   CREATE TABLE inv (
//     id INT AUTO_INCREMENT PRIMARY KEY,
//     name VARCHAR(255) NOT NULL,
//     quantity INT NOT NULL,
//     price DECIMAL(10, 2) NOT NULL
//   )
// `;

// pool.query(createTableQuery, (err, results) => {
//   if (err) {
//     console.error('Error creating table:', err);
//     return;
//   }
//   console.log('Table created successfully:', results);
// });
