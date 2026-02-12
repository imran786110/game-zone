// 3D Background with particles
function init3DBackground() {
    const bg = document.createElement('div');
    bg.className = 'bg-3d';
    document.body.insertBefore(bg, document.body.firstChild);

    // Create floating particles
    for (let i = 0; i < 20; i++) {
        const particle = document.createElement('div');
        particle.className = 'particle';
        particle.style.width = Math.random() * 5 + 2 + 'px';
        particle.style.height = particle.style.width;
        particle.style.left = Math.random() * 100 + '%';
        particle.style.animationDelay = Math.random() * 15 + 's';
        particle.style.animationDuration = (Math.random() * 10 + 10) + 's';
        bg.appendChild(particle);
    }
}

// Initialize on page load
if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', init3DBackground);
} else {
    init3DBackground();
}
