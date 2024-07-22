document.getElementById('wakeLink').addEventListener('click', function(event) {
    event.preventDefault(); // Prevenim navigarea link-ului
    fetch('https://wol.andreinita.com/api/wake', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        }
    })
    .then(response => response.json())
    .then(data => {
        console.log(data);
        alert('Calculatorul a fost trezit!');
    })
    .catch(error => {
        console.error('Error:', error);
        alert('Calculatorul NU a fost trezit din cauza unei erori!');
    });
});
