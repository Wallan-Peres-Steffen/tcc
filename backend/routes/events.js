const express = require('express');
const router = express.Router();
const Event = require('../models/Event');

// GET todos os eventos
router.get('/', async (req, res) => {
    try {
        const events = await Event.find().sort({ date: 1 });
        res.json(events);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

// GET evento por ID
router.get('/:id', async (req, res) => {
    try {
        const event = await Event.findById(req.params.id);
        if (!event) return res.status(404).json({ error: 'Evento não encontrado' });
        res.json(event);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

// POST criar evento
router.post('/', async (req, res) => {
    try {
        const event = new Event(req.body);
        await event.save();
        res.status(201).json(event);
    } catch (error) {
        res.status(400).json({ error: error.message });
    }
});

// PUT atualizar evento
router.put('/:id', async (req, res) => {
    try {
        const event = await Event.findByIdAndUpdate(req.params.id, req.body, { new: true });
        if (!event) return res.status(404).json({ error: 'Evento não encontrado' });
        res.json(event);
    } catch (error) {
        res.status(400).json({ error: error.message });
    }
});

// DELETE excluir evento
router.delete('/:id', async (req, res) => {
    try {
        const event = await Event.findByIdAndDelete(req.params.id);
        if (!event) return res.status(404).json({ error: 'Evento não encontrado' });
        res.json({ message: 'Evento excluído com sucesso' });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

module.exports = router;