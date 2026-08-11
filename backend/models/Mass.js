const mongoose = require('mongoose');

const MassSchema = new mongoose.Schema({
    day: {
        type: String,
        enum: ['sunday', 'monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday', 'weekday', 'special'],
        required: true
    },
    time: { type: String, required: true },
    type: { type: String, required: true },
    // Campos para missas especiais
    date: { type: String },
    location: { type: String },
    celebrant: { type: String },
    description: { type: String },
    createdAt: { type: Date, default: Date.now }
});

module.exports = mongoose.model('Mass', MassSchema);