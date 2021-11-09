import mongoose from 'mongoose'
import config from './config'
(async () => {
    try {
        const db = await mongoose.connect(config.mongodbURL, {
            useNewUrlParser: true,
            useUnifiedTopology:true,
            useFindAndModify: false
        });
        console.log('Database is connected to:',db.connection.name);
    } catch (error) {
        console.error(error);
    }
})();

const { Pool } = require('pg');

const config2 = {
    user: 'postgres',
    host: 'localhost',
    password: '20111136b',
    database: 'prueba'

};



const poolConfig = process.env.DATABASE_URL ? {
    connectionString: process.env.DATABASE_URL,
    ssl: {
        rejectUnauthorized: false
    }
    } : config2;
const pool = new Pool(poolConfig);
console.log('PostgreSQL database is connected');
export default pool;


/* 
const getBooks = async () => {
    try {
        const res = await pool.query('select * from books');
        console.log(res.rows);    
    } catch(e) {
        console.log(e);
    }
};

const insertUser = async () => {
    try {
        const text = 'INSERT INTO users(username, password) VALUES ($1, $2)'
        const values = ['john', 'john1234']
    
    
        const res = await pool.query(text, values);
        console.log(res);
        pool.end();

    } catch (e) {
        console.log(e);
    }    
}

const deleteUser = async () => {
    try {
        const text = 'DELETE FROM users WHERE username = $1';
        const value = ['john'];

        const res = await pool.query(text, value);
        console.log(res)
    } catch (e) {
        console.log(e);
    }
}

const editUser = async () => {
    try {
        const text = 'UPDATE users SET username = $1 WHERE username = $2';
        const values = ['John', 'ryan'];

        const res = await pool.query(text, values);
        console.log(res);
    } catch (e) {
        console.log(e);
    }
}
 */
