const { DataTypes } = require("sequelize");
const sequelize = require("../../config/database");

const User = sequelize.define(
  "User",
  {
    id: {
      type: DataTypes.INTEGER,
      primaryKey: true,
      autoIncrement: true,
      allowNull: false,
    },
    username: {
      type: DataTypes.TEXT,
      allowNull: false,
      unique: true,
    },
    password: {
      type: DataTypes.TEXT,
      allowNull: false,
    },
    email: {
      type: DataTypes.TEXT,
      allowNull: false,
      unique: true,
    },
    image: {
      type: DataTypes.TEXT,
      allowNull: true,
    },
    fullname: {
      type: DataTypes.TEXT,
      allowNull: true,
    },
    reset_key: {
      type: DataTypes.TEXT,
      allowNull: true,
    },
  },
  {
    tableName: "users",
    timestamps: false, // Cambia a true si usas createdAt y updatedAt
  },
);

module.exports = User;
