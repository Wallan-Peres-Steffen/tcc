const express = require('express');
const router = express.Router();
const Retreat = require('../models/Retreat');

// GET todos os retiros
router.get('/', async (req, res) => {
    try {
        const retreats = await Retreat.find().sort({ startDate: 1 });
        res.json(retreats);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

// GET retiro por ID
router.get('/:id', async (req, res) => {
    try {
        const retreat = await Retreat.findById(req.params.id);
        if (!retreat) return res.status(404).json({ error: 'Retiro não encontrado' });
        res.json(retreat);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

// GET retiros ativos
router.get('/active', async (req, res) => {
    try {
        const retreats = await Retreat.find({ status: 'active' }).sort({ startDate: 1 });
        res.json(retreats);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

// POST criar retiro
router.post('/', async (req, res) => {
    try {
        const retreat = new Retreat(req.body);
        await retreat.save();
        res.status(201).json(retreat);
    } catch (error) {
        res.status(400).json({ error: error.message });
    }
});

// PUT atualizar retiro
router.put('/:id', async (req, res) => {
    try {
        const retreat = await Retreat.findByIdAndUpdate(req.params.id, req.body, { new: true });
        if (!retreat) return res.status(404).json({ error: 'Retiro não encontrado' });
        res.json(retreat);
    } catch (error) {
        res.status(400).json({ error: error.message });
    }
});

// DELETE excluir retiro
router.delete('/:id', async (req, res) => {
    try {
        const retreat = await Retreat.findByIdAndDelete(req.params.id);
        if (!retreat) return res.status(404).json({ error: 'Retiro não encontrado' });
        res.json({ message: 'Retiro excluído com sucesso' });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

module.exports = router;