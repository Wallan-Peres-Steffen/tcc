require('dotenv').config();
const express = require('express');
const cors = require('cors');
const connectDB = require('./db/connection');

const app = express();

// Conectar ao MongoDB
connectDB();

// Middlewares
app.use(cors());
app.use(express.json());

// Rotas
app.use('/api/events', require('./routes/events'));
app.use('/api/masses', require('./routes/masses'));
app.use('/api/retreats', require('./routes/retreats'));

// Rota de teste
app.get('/api/health', (req, res) => {
    res.json({ status: 'ok', message: 'Servidor rodando!' });
});

const PORT = process.env.PORT || 5000;
app.listen(PORT, () => {
    console.log(`🚀 Servidor rodando na porta ${PORT}`);
});

