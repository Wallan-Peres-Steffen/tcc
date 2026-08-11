// ============================================
// DATABASE MANAGER - LocalStorage
// ============================================

const DB = {
    COLLECTIONS: {
        EVENTS: 'db_events',
        MASSES: 'db_masses',
        RETREATS: 'db_retreats',
        THEME: 'db_theme',
        USERS: 'db_users'
    },

    // ============================================
    // MÉTODOS GENÉRICOS
    // ============================================

    getCollection(collectionName) {
        try {
            const data = localStorage.getItem(collectionName);
            return data ? JSON.parse(data) : [];
        } catch (error) {
            console.error(`Erro ao ler coleção ${collectionName}:`, error);
            return [];
        }
    },

    setCollection(collectionName, data) {
        try {
            localStorage.setItem(collectionName, JSON.stringify(data));
            return true;
        } catch (error) {
            console.error(`Erro ao salvar coleção ${collectionName}:`, error);
            return false;
        }
    },

    generateId() {
        return Date.now().toString(36) + Math.random().toString(36).substr(2, 5);
    },

    // ============================================
    // EVENTOS
    // ============================================

    getEvents() {
        return this.getCollection(this.COLLECTIONS.EVENTS);
    },

    saveEvents(events) {
        return this.setCollection(this.COLLECTIONS.EVENTS, events);
    },

    addEvent(event) {
        const events = this.getEvents();
        event.id = this.generateId();
        event.createdAt = new Date().toISOString();
        events.push(event);
        this.saveEvents(events);
        return event;
    },

    updateEvent(id, updatedData) {
        const events = this.getEvents();
        const index = events.findIndex(e => e.id === id);
        if (index === -1) return null;
        events[index] = { ...events[index], ...updatedData, updatedAt: new Date().toISOString() };
        this.saveEvents(events);
        return events[index];
    },

    deleteEvent(id) {
        const events = this.getEvents();
        const filtered = events.filter(e => e.id !== id);
        this.saveEvents(filtered);
        return true;
    },

    getEvent(id) {
        const events = this.getEvents();
        return events.find(e => e.id === id) || null;
    },

    getEventsByCategory(category) {
        const events = this.getEvents();
        return events.filter(e => e.category === category);
    },

    getUpcomingEvents(limit = 10) {
        const events = this.getEvents();
        const now = new Date();
        return events
            .filter(e => new Date(e.date) >= now && e.status === 'published')
            .sort((a, b) => new Date(a.date) - new Date(b.date))
            .slice(0, limit);
    },

    // ============================================
    // MISSAS
    // ============================================

    getMasses() {
        return this.getCollection(this.COLLECTIONS.MASSES);
    },

    saveMasses(masses) {
        return this.setCollection(this.COLLECTIONS.MASSES, masses);
    },

    addMass(mass) {
        const masses = this.getMasses();
        mass.id = this.generateId();
        mass.createdAt = new Date().toISOString();
        masses.push(mass);
        this.saveMasses(masses);
        return mass;
    },

    updateMass(id, updatedData) {
        const masses = this.getMasses();
        const index = masses.findIndex(m => m.id === id);
        if (index === -1) return null;
        masses[index] = { ...masses[index], ...updatedData, updatedAt: new Date().toISOString() };
        this.saveMasses(masses);
        return masses[index];
    },

    deleteMass(id) {
        const masses = this.getMasses();
        const filtered = masses.filter(m => m.id !== id);
        this.saveMasses(filtered);
        return true;
    },

    getMassesByDay(day) {
        const masses = this.getMasses();
        return masses.filter(m => m.day === day);
    },

    getMass(id) {
        const masses = this.getMasses();
        return masses.find(m => m.id === id) || null;
    },

    // ============================================
    // RETIROS
    // ============================================

    getRetreats() {
        return this.getCollection(this.COLLECTIONS.RETREATS);
    },

    saveRetreats(retreats) {
        return this.setCollection(this.COLLECTIONS.RETREATS, retreats);
    },

    addRetreat(retreat) {
        const retreats = this.getRetreats();
        retreat.id = this.generateId();
        retreat.createdAt = new Date().toISOString();
        retreats.push(retreat);
        this.saveRetreats(retreats);
        return retreat;
    },

    updateRetreat(id, updatedData) {
        const retreats = this.getRetreats();
        const index = retreats.findIndex(r => r.id === id);
        if (index === -1) return null;
        retreats[index] = { ...retreats[index], ...updatedData, updatedAt: new Date().toISOString() };
        this.saveRetreats(retreats);
        return retreats[index];
    },

    deleteRetreat(id) {
        const retreats = this.getRetreats();
        const filtered = retreats.filter(r => r.id !== id);
        this.saveRetreats(filtered);
        return true;
    },

    getRetreat(id) {
        const retreats = this.getRetreats();
        return retreats.find(r => r.id === id) || null;
    },

    getActiveRetreats() {
        const retreats = this.getRetreats();
        return retreats.filter(r => r.status === 'active');
    },

    getUpcomingRetreats(limit = 10) {
        const retreats = this.getRetreats();
        const now = new Date();
        return retreats
            .filter(r => new Date(r.startDate) >= now && r.status === 'active')
            .sort((a, b) => new Date(a.startDate) - new Date(b.startDate))
            .slice(0, limit);
    },

    // ============================================
    // TEMA DO MÊS
    // ============================================

    getTheme() {
        return this.getCollection(this.COLLECTIONS.THEME)[0] || null;
    },

    saveTheme(theme) {
        return this.setCollection(this.COLLECTIONS.THEME, [theme]);
    },

    updateTheme(updatedData) {
        const current = this.getTheme();
        const newTheme = { ...current, ...updatedData, updatedAt: new Date().toISOString() };
        this.saveTheme(newTheme);
        return newTheme;
    },

    // ============================================
    // USUÁRIOS
    // ============================================

    getUsers() {
        return this.getCollection(this.COLLECTIONS.USERS);
    },

    saveUsers(users) {
        return this.setCollection(this.COLLECTIONS.USERS, users);
    },

    addUser(user) {
        const users = this.getUsers();
        user.id = this.generateId();
        user.createdAt = new Date().toISOString();
        users.push(user);
        this.saveUsers(users);
        return user;
    },

    updateUser(id, updatedData) {
        const users = this.getUsers();
        const index = users.findIndex(u => u.id === id);
        if (index === -1) return null;
        users[index] = { ...users[index], ...updatedData, updatedAt: new Date().toISOString() };
        this.saveUsers(users);
        return users[index];
    },

    deleteUser(id) {
        const users = this.getUsers();
        const filtered = users.filter(u => u.id !== id);
        this.saveUsers(filtered);
        return true;
    },

    getUser(id) {
        const users = this.getUsers();
        return users.find(u => u.id === id) || null;
    },

    getUserByEmail(email) {
        const users = this.getUsers();
        return users.find(u => u.email === email) || null;
    },

    // ============================================
    // DADOS INICIAIS
    // ============================================

    initializeData() {
        // Inicializar dados de exemplo se estiverem vazios
        if (this.getEvents().length === 0) {
            this.saveEvents([
                {
                    id: this.generateId(),
                    title: "Festa de São Francisco",
                    description: "Celebração especial em honra ao nosso padroeiro com missa solene, procissão e festa comunitária.",
                    date: "2025-05-15",
                    time: "19:00",
                    location: "Igreja Matriz",
                    category: "festa",
                    responsible: "Pe. João Silva",
                    status: "published",
                    createdAt: new Date().toISOString()
                },
                {
                    id: this.generateId(),
                    title: "Curso de Batismo",
                    description: "Encontro formativo para pais e padrinhos que desejam batizar suas crianças na comunidade.",
                    date: "2025-05-18",
                    time: "20:00",
                    location: "Salão Paroquial",
                    category: "formacao",
                    responsible: "Pe. Carlos Oliveira",
                    status: "published",
                    createdAt: new Date().toISOString()
                }
            ]);
        }

        if (this.getMasses().length === 0) {
            this.saveMasses([
                { id: this.generateId(), day: "sunday", time: "07:00", type: "Missa Matinal" },
                { id: this.generateId(), day: "sunday", time: "09:00", type: "Missa da Família" },
                { id: this.generateId(), day: "sunday", time: "11:00", type: "Missa Solene" },
                { id: this.generateId(), day: "weekday", time: "07:00", type: "Missa da Manhã" },
                { id: this.generateId(), day: "weekday", time: "12:00", type: "Missa do Meio-Dia" },
                { id: this.generateId(), day: "weekday", time: "19:30", type: "Missa da Noite" },
                { id: this.generateId(), day: "saturday", time: "08:00", type: "Missa da Manhã" },
                { id: this.generateId(), day: "saturday", time: "17:00", type: "Missa Vespertina" },
                { id: this.generateId(), day: "saturday", time: "19:00", type: "Missa Dominical Antecipada" }
            ]);
        }

        if (this.getRetreats().length === 0) {
            this.saveRetreats([
                {
                    id: this.generateId(),
                    title: "Retiro de Silêncio e Oração",
                    description: "Um fim de semana dedicado ao silêncio, à oração e à contemplação.",
                    startDate: "2025-05-20",
                    endDate: "2025-05-22",
                    location: "Casa de Retiros Monte Carmelo",
                    type: "silence",
                    price: 250.00,
                    capacity: 30,
                    responsible: "Pe. João Silva",
                    status: "active",
                    requirements: "Bíblia, caderno para anotações, roupa de cama e banho.",
                    contact: "(11) 9999-9999",
                    createdAt: new Date().toISOString()
                },
                {
                    id: this.generateId(),
                    title: "Encontro de Casais",
                    description: "Um retiro especial para casais que desejam fortalecer sua relação à luz da fé.",
                    startDate: "2025-06-10",
                    endDate: "2025-06-12",
                    location: "Centro de Espiritualidade São José",
                    type: "couples",
                    price: 400.00,
                    capacity: 20,
                    responsible: "Pe. Carlos Oliveira",
                    status: "active",
                    requirements: "Trazer foto do casamento, Bíblia.",
                    contact: "casais@paroquia.org",
                    createdAt: new Date().toISOString()
                }
            ]);
        }

        if (!this.getTheme()) {
            this.saveTheme({
                title: "Amor e Caridade",
                description: "Mês dedicado a refletir sobre o amor ao próximo e a prática da caridade em nossa comunidade. Inspirados pelo exemplo de São Francisco, somos chamados a ser instrumentos da paz e do amor de Deus.",
                intro: "Neste mês, convidamos todos a meditar sobre o amor como fundamento da vida cristã e a colocar em prática atos concretos de caridade.",
                createdAt: new Date().toISOString()
            });
        }
    }
};

// Inicializar dados automaticamente
DB.initializeData();

// ============================================
// EXPORTAÇÃO
// ============================================

// Se estiver usando módulos
if (typeof module !== 'undefined' && module.exports) {
    module.exports = DB;
}

// Se estiver no navegador
if (typeof window !== 'undefined') {
    window.DB = DB;
}