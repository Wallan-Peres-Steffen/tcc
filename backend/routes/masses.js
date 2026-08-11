const express = require('express');
const router = express.Router();
const Mass = require('../models/Mass');

// GET todas as missas
router.get('/', async (req, res) => {
    try {
        const masses = await Mass.find().sort({ createdAt: -1 });
        res.json(masses);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

// GET missa por ID
router.get('/:id', async (req, res) => {
    try {
        const mass = await Mass.findById(req.params.id);
        if (!mass) return res.status(404).json({ error: 'Missa não encontrada' });
        res.json(mass);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

// GET missas por dia (sunday, weekday, saturday, special)
router.get('/day/:day', async (req, res) => {
    try {
        const masses = await Mass.find({ day: req.params.day }).sort({ time: 1 });
        res.json(masses);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

// POST criar missa
router.post('/', async (req, res) => {
    try {
        const mass = new Mass(req.body);
        await mass.save();
        res.status(201).json(mass);
    } catch (error) {
        res.status(400).json({ error: error.message });
    }
});

// PUT atualizar missa
router.put('/:id', async (req, res) => {
    try {
        const mass = await Mass.findByIdAndUpdate(req.params.id, req.body, { new: true });
        if (!mass) return res.status(404).json({ error: 'Missa não encontrada' });
        res.json(mass);
    } catch (error) {
        res.status(400).json({ error: error.message });
    }
});

// DELETE excluir missa
router.delete('/:id', async (req, res) => {
    try {
        const mass = await Mass.findByIdAndDelete(req.params.id);
        if (!mass) return res.status(404).json({ error: 'Missa não encontrada' });
        res.json({ message: 'Missa excluída com sucesso' });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

module.exports = router;