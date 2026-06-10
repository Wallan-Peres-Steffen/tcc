// theme-manager.js - Coloque este arquivo na mesma pasta das suas páginas HTML

// Gerenciamento de Tema
function setTheme(theme) {
    if (theme === 'dark') {
        document.body.classList.add('dark-mode');
        // Atualizar botões de tema se existirem
        const lightBtn = document.querySelector('.theme-light');
        const darkBtn = document.querySelector('.theme-dark');
        if (lightBtn && darkBtn) {
            lightBtn.classList.remove('active');
            darkBtn.classList.add('active');
        }
    } else {
        document.body.classList.remove('dark-mode');
        const lightBtn = document.querySelector('.theme-light');
        const darkBtn = document.querySelector('.theme-dark');
        if (lightBtn && darkBtn) {
            lightBtn.classList.add('active');
            darkBtn.classList.remove('active');
        }
    }
    localStorage.setItem('theme', theme);
}

function toggleTheme() {
    const isDark = document.body.classList.contains('dark-mode');
    setTheme(isDark ? 'light' : 'dark');
}

function loadSavedTheme() {
    const savedTheme = localStorage.getItem('theme') || 'light';
    setTheme(savedTheme);
}

function initThemeManager() {
    loadSavedTheme();
    
    // Configurar botão de tema se existir na página
    const themeToggleBtn = document.getElementById('themeToggleBtn');
    if (themeToggleBtn) {
        themeToggleBtn.addEventListener('click', toggleTheme);
    }
}

// Inicializar quando o DOM estiver carregado
document.addEventListener('DOMContentLoaded', initThemeManager);