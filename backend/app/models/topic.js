const { DataTypes } = require('sequelize');
const sequelize = require('../../config/database');

// Definir el modelo Topic
const Topic = sequelize.define('Topic', {
    id: {
        type: DataTypes.INTEGER,
        primaryKey: true,
        autoIncrement: true
    },
    name: {
        type: DataTypes.STRING(25),
        allowNull: false
    },
    icon: {
        type: DataTypes.STRING(25),
        allowNull: true
    },
    description: {
        type: DataTypes.STRING(25),
        allowNull: true
    }
}, {
    tableName: 'topics',  // 👈 Asegura que Sequelize use la tabla correcta
    timestamps: false     // 👈 Si NO tienes campos createdAt / updatedAt
});

module.exports = Topic;
