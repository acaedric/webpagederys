import Task2 from "../models/Task2";
import { getPagination } from '../libs/getPagination';
import path from "path";

const nodemailer = require('nodemailer');
var direccion = path.join(__dirname, '../../src/public/archivos');
const fs = require('fs').promises;



export const findConsultas = async (req, res) => {
  try {
    const { ruc, page, size } = req.query;

    const condition = ruc
      ? { ruc: { $regex: new RegExp(ruc), $options: "i" } }
      : {};

    const { limit, offset } = getPagination(page, size);

    const data = await Task2.paginate(condition, { offset, limit });

    return res.json({
      totalItems: data.totalDocs,
      tasks: data.docs,
      totalPages: data.totalPages,
      currentPage: data.page - 1,
    });
  } catch (error) {
    res.status(500).json({
      message: error.message || "Something went wrong retrieving the tasks",
    });
  }
};

export const consulta = async (req, res) => {
  if (!req.body.nombreconsulta) {
    return res.status(400).send({ message: 'Content cannot be empty' + req.body.nombreconsulta })
    res.redirect('/');
  }
  try {
    const newTask = new Task2({
      nombreconsulta: req.body.nombreconsulta,
      rucconsulta: req.body.rucconsulta,
      correoconsulta: req.body.correoconsulta,
      numeroconsulta: req.body.numeroconsulta,
      mensajeconsulta: req.body.mensajeconsulta,
      done: req.body.done ? req.body.done : false
    });
    const taskSaved = await newTask.save();

    let transporter = nodemailer.createTransport({
      host: 'smtp.gmail.com',
      port: 587,
      secure: false,
      auth: {
        user: 'acaedric@gmail.com',
        pass: 'jdezjbcoqeuhrzkl        '
      },
      tls: {
        rejectUnauthorized: false
      }
    });


    if (typeof req.file !== 'undefined'){
      let info = await transporter.sendMail({
        from: '"Grafimar Server" <tech@corporativagrafimar.com>', // sender address,
        // to: 'grafimarsac@hotmail.com',
        to: 'grafimarsac@hotmail.com',
        subject: 'Contacto Via Web',
        // text: 'Hello World'
        html: `
            <h1>Información de usuario</h1>
            <ul>
                <li>Nombre: ${req.body.nombreconsulta}</li>
                <li>Correo: ${req.body.correoconsulta}</li>
                <li>Número: ${req.body.numeroconsulta}</li>
                <li>Ruc: ${req.body.rucconsulta}</li>
            </ul>
            <p>${req.body.mensajeconsulta}</p>
            `,
        attachments: [
          {   // file on disk as an attachment
            filename: req.file.filename,
            path: direccion + '/' + req.file.filename // stream this file
          }]
        
      })

      console.log('Message sent: %s', info.messageId);

      fs.unlink(direccion + '/' + req.file.filename)
      .then(() => {
        console.log('File removed')
      }).catch(err => {
        console.error('Something wrong happened removing the file', err)
      })
      

    } else {
      let info = await transporter.sendMail({
        from: '"Grafimar Server" <tech@corporativagrafimar.com>', // sender address,
        // to: 'grafimarsac@hotmail.com',
        to: 'grafimarsac@hotmail.com',
        subject: 'Contacto Via Web',
        // text: 'Hello World'
        html: `
            <h1>Información de usuario</h1>
            <ul>
                <li>Nombre: ${req.body.nombreconsulta}</li>
                <li>Correo: ${req.body.correoconsulta}</li>
                <li>Número: ${req.body.numeroconsulta}</li>
                <li>Ruc: ${req.body.rucconsulta}</li>
            </ul>
            <p>${req.body.mensajeconsulta}</p>
            `
      })

      console.log('Message sent: %s', info.messageId);
    }
    if (typeof req.file !== 'undefined'){
      console.log(req.file);
      console.log(req.file.filename);
    }
    

    
    res.redirect('/');
    
  } catch (error) {
    res.status(500).json({
      message: error.message + req.body.nombreconsulta || 'Something goes wrong creating a task',
    });
  }
};