const mongoose = require('mongoose');

const RetreatSchema = new mongoose.Schema({
    title: { type: String, required: true },
    description: { type: String, required: true },
    startDate: { type: String, required: true },
    endDate: { type: String, required: true },
    location: { type: String, required: true },
    type: { 
        type: String, 
        enum: ['silence', 'couples', 'youth', 'healing', 'other'],
        required: true 
    },
    price: { type: Number, default: 0 },
    capacity: { type: Number, default: 0 },
    responsible: { type: String },
    status: { 
        type: String, 
        enum: ['active', 'completed', 'cancelled'],
        default: 'active' 
    },
    requirements: { type: String },
    contact: { type: String },
    image: { type: String }, // Base64
    createdAt: { type: Date, default: Date.now }
});

module.exports = mongoose.model('Retreat', RetreatSchema);