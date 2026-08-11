const mongoose = require('mongoose');

const EventSchema = new mongoose.Schema({
    title: { type: String, required: true },
    description: { type: String, required: true },
    date: { type: String, required: true },
    time: { type: String, required: true },
    location: { type: String, required: true },
    category: { 
        type: String, 
        enum: ['missa', 'formacao', 'festa', 'servico', 'outro'],
        required: true 
    },
    responsible: { type: String },
    status: { 
        type: String, 
        enum: ['published', 'draft'],
        default: 'published' 
    },
    notes: { type: String },
    createdAt: { type: Date, default: Date.now }
});

module.exports = mongoose.model('Event', EventSchema);