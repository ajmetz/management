const ctx = document.getElementById('myChart');

let dataValue = {
    datasets: [{
        data: [117,107,74,59,47,47,45,43,42,39,33,29,28,26,18,17,17,6,9,7,6,3,3,2],
        rotation: 0,
        backgroundColor: [
          'rgb(255, 200, 0)',
          'rgb(100, 200, 100)',
          'rgb(255, 100, 100)'
        ],
        hoverOffset: 100
    }],
    labels: [
        'Solutions',
        'Logging',
        'Unaccounted',
        'Getting Ready',
        'Web Browsing',
        'Youtube',
        'Phone',
        'Coding',
        'Food & Exercise',
        'Messaging',
        'Distress',
        'Email',
        'Shopping',
        'Recap',
        'Internet Banking',
        'Analytics',
        'Toilet',
        'Planning',
        'Writing',
        'Thinking',
        'Social Media',
        'GamesMags',
        'TimeTracking',
        'Work'
    ],
}

new Chart(ctx, {
    type: 'pie',
    data: dataValue,

    options: {
        plugins: {
            legend: {
                display: false,
            }
        },
        layout: {
            padding: 50
        },
        // Event handler for a click on a chart element
        onClick: function (event, elements) {
    
            const clickedElement = elements[0];
    
            const datasetIndex = clickedElement.index;
    
            const label = dataValue.labels[datasetIndex];
    
            const labelValue = dataValue.datasets[0].data[datasetIndex];
    
            // Show an alert with information about the clicked segment
            alert(`Clicked on: ${label} and it\'s value is ${labelValue}`);
            window.open('https://www.unitedgames.co.uk','_blank');
        }
        
    }
});
