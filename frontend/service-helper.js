// ============================================
// SERVICE HELPER - Funções auxiliares para templates
// ============================================

const ServiceHelper = {
    // ============================================
    // FORMATAÇÃO DE DATAS
    // ============================================

    formatDate(dateStr) {
        if (!dateStr) return '';
        const date = new Date(dateStr);
        return date.toLocaleDateString('pt-BR');
    },

    formatDateLong(dateStr) {
        if (!dateStr) return '';
        const date = new Date(dateStr);
        return date.toLocaleDateString('pt-BR', {
            weekday: 'long',
            year: 'numeric',
            month: 'long',
            day: 'numeric'
        });
    },

    formatTime(timeStr) {
        if (!timeStr) return '';
        return timeStr.substring(0, 5);
    },

    formatDateTime(dateStr, timeStr) {
        if (!dateStr) return '';
        const date = new Date(dateStr);
        const time = timeStr ? ` • ${timeStr.substring(0, 5)}` : '';
        return date.toLocaleDateString('pt-BR', {
            weekday: 'long',
            year: 'numeric',
            month: 'long',
            day: 'numeric'
        }) + time;
    },

    // ============================================
    // CATEGORIAS E LABELS
    // ============================================

    getCategoryLabel(category) {
        const labels = {
            'missa': 'Missa',
            'formacao': 'Formação',
            'festa': 'Festa',
            'servico': 'Serviço',
            'outro': 'Outro'
        };
        return labels[category] || category;
    },

    getCategoryClass(category) {
        const classes = {
            'missa': 'missa',
            'formacao': 'formacao',
            'festa': 'festa',
            'servico': 'servico'
        };
        return classes[category] || '';
    },

    getStatusLabel(status) {
        const labels = {
            'active': 'Ativo',
            'completed': 'Concluído',
            'cancelled': 'Cancelado',
            'published': 'Publicado',
            'draft': 'Rascunho',
            'pending': 'Pendente'
        };
        return labels[status] || status;
    },

    getStatusClass(status) {
        const classes = {
            'active': 'active',
            'completed': 'completed',
            'cancelled': 'cancelled',
            'published': 'published',
            'draft': 'draft'
        };
        return classes[status] || '';
    },

    getDayLabel(day) {
        const labels = {
            'sunday': 'Domingo',
            'weekday': 'Segunda a Sexta',
            'saturday': 'Sábado'
        };
        return labels[day] || day;
    },

    getMinistryLabel(ministry) {
        const labels = {
            'acolito': 'Acólitos',
            'musico': 'Músicos',
            'leitor': 'Leitores',
            'coral': 'Coral',
            'dizimo': 'Dízimo',
            'outro': 'Outro'
        };
        return labels[ministry] || ministry;
    },

    getRetreatTypeLabel(type) {
        const labels = {
            'silence': 'Silêncio e Oração',
            'couples': 'Casais',
            'youth': 'Juventude',
            'healing': 'Cura Interior',
            'other': 'Outro'
        };
        return labels[type] || type;
    },

    // ============================================
    // CORES
    // ============================================

    getAvatarColor(id) {
        const colors = [
            '#2c5530', '#4a7c59', '#d4af37', '#8b4513',
            '#1a3c23', '#6f42c1', '#20c997', '#fd7e14'
        ];
        const index = typeof id === 'string' ? id.length % colors.length : id % colors.length;
        return colors[index];
    },

    // ============================================
    // TRUNCAR TEXTO
    // ============================================

    truncate(text, maxLength = 150) {
        if (!text) return '';
        if (text.length <= maxLength) return text;
        return text.substring(0, maxLength) + '...';
    },

    // ============================================
    // DURATION
    // ============================================

    getDurationDays(startDate, endDate) {
        if (!startDate || !endDate) return 0;
        const start = new Date(startDate);
        const end = new Date(endDate);
        return Math.ceil((end - start) / (1000 * 60 * 60 * 24)) + 1;
    },

    // ============================================
    // INICIAIS
    // ============================================

    getInitials(name) {
        if (!name) return '';
        return name.split(' ')
            .map(n => n[0])
            .join('')
            .toUpperCase()
            .substring(0, 2);
    }
};

// ============================================
// EXPORTAÇÃO
// ============================================

if (typeof module !== 'undefined' && module.exports) {
    module.exports = ServiceHelper;
}

if (typeof window !== 'undefined') {
    window.ServiceHelper = ServiceHelper;
}