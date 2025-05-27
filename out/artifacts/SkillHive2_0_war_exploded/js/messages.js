document.addEventListener('DOMContentLoaded', () => {
    console.log('messages.js loaded');
    
    const cards = document.querySelectorAll('.card');
    console.log(`Found cards: ${cards.length}`);
    
    cards.forEach(card => {
        // Chiudi card dopo 1,5 secondi
        setTimeout(() => {
            card.classList.add('slide-out');
            setTimeout(() => card.remove(), 300);
        }, 1500);
        
        // Chiudi card cliccando sulla croce
        const closeIcon = card.querySelector('.cross-icon');
        if (closeIcon) {
            closeIcon.addEventListener('click', () => {
                card.classList.add('slide-out');
                setTimeout(() => card.remove(), 300);
            });
        }
    });
});