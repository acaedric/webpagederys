import Task2 from "../models/Task2";
import { getPagination } from '../libs/getPagination';
import path from "path";
import pool from "../database";

const nodemailer = require('nodemailer');
var direccion = path.join(__dirname, '../../src/public/archivos');
const fs = require('fs').promises;



export const findConsultas = async(req, res) => {
    try {
        const { ruc, page, size } = req.query;

        const condition = ruc ? { ruc: { $regex: new RegExp(ruc), $options: "i" } } : {};

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

export const consulta = async(req, res) => {
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


        if (typeof req.file !== 'undefined') {
            let info = await transporter.sendMail({
                from: '"Grafimar Server" <tech@corporativagrafimar.com>', // sender address,
                // to: 'grafimarsac@hotmail.com',
                to: 'acaedricnewyt@gmail.com',
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
                attachments: [{ // file on disk as an attachment
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
                to: 'acaedricnewyt@gmail.com',
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
        if (typeof req.file !== 'undefined') {
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




export const crearPersona = async(req, res) => {

    try {
        const text = 'INSERT INTO persona (doc_id, apellidos, nombre_pila, foto, fec_nac, sexo, direcc_email, nombre_usuario, password, rol, pais, ciudad) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12)'
        const values = [req.body.doc_id, req.body.apellidos, req.body.nombre_pila, req.body.foto, req.body.fec_nac, req.body.sexo, req.body.direcc_email, req.body.nombre_usuario, req.body.password, req.body.rol, req.body.pais, req.body.ciudad]
        const res = await pool.query(text, values)

    } catch (e) {
        console.log(e);
        res.status(500).send('Hubo un error');
    }
}

export const crearPostulante = async(req, res) => {

    try {

        const text = 'INSERT INTO postulante (link_linkedin, lugar_residencia, antecedentes_penales, curriculum_vitae, situacion_laboral_actual, tipo_contrato_deseado, movilidad, doc_id) VALUES ($1, $2, $3, $4, $5, $6, $7, $8)'
        const values = [req.body.link_linkedin, req.body.lugar_residencia, '', req.body.curriculum_vitae, req.body.situacion_laboral_actual, req.body.tipo_contrato_deseado, req.body.movilidad, req.body.doc_id];
        const res = await pool.query(text, values)

    } catch (e) {
        console.log(e);
        res.status(500).send('Hubo un error XD');
    }
}

export const obtenerPersonas = async(req, res) => {
    try {
        const respuesta = await pool.query('select * from persona');
        console.log(respuesta.rows[0]);
        const { doc_id, apellidos, nombre_pila, foto, fec_nac, sexo, direcc_email, nombre_usuario, password, rol, pais, ciudad } = respuesta.rows[0];
        const personas = { doc_id, apellidos, nombre_pila, foto, fec_nac, sexo, direcc_email, nombre_usuario, password, rol, pais, ciudad };

        res.status(200).json(respuesta.rows);
    } catch (e) {
        console.log(e);
        res.status(500).send('Hubo un error');
    }
};

export const obtenerConvocatorias = async(req, res) => {
    try {
        const respuesta = await pool.query('select * from convocatoria');

        res.status(200).json(respuesta.rows);
    } catch (e) {
        console.log(e);
        res.status(500).send('Hubo un error');
    }
};

export const obtenerConvocatoriasPostulantebyID = async(req, res) => {
    try {
        const value1 = [req.params.id];
        const text = 'select * from convocatoria pt INNER JOIN persona p ON p.doc_id = pt.doc_id AND p.nombre_usuario = $1';
        const datosconvocatoria = await pool.query(text, value1)
        const respuesta = await pool.query('select * from convocatoria');
        res.status(200).json(datosconvocatoria.rows[0]);
    } catch (e) {
        console.log(e);
        res.status(500).send('Hubo un error');
    }
};

export const obtenerPersonasbyID = async(req, res) => {
    try {
        console.log(req.params);
        console.log(req.params.id);
        console.log(typeof(req.params.id));
        const value1 = [req.params.id];
        const text = 'select * from postulante pt INNER JOIN persona p ON p.doc_id = pt.doc_id AND p.nombre_usuario = $1';
        const datospostulante = await pool.query(text, value1)
        console.log(datospostulante.rows[0]);
        if (datospostulante.rows.length === 0) {
            const text2 = 'select * from tecnico_seleccion pt INNER JOIN persona p ON p.doc_id = pt.doc_id AND p.nombre_usuario = $1';
            const datostecnicoseleccion = await pool.query(text2, value1)
            res.status(200).json(datostecnicoseleccion.rows[0]);
        } {
            res.status(200).json(datospostulante.rows[0]);
        }
    } catch (e) {
        console.log(e);
        res.status(500).send('Hubo un error');
    }
};

export const iniciarsesion = async(req, res) => {
    try {
        const value1 = [req.body.nombre_usuario];
        const text = 'select * from persona where nombre_usuario = $1';
        const datosusuario = await pool.query(text, value1)
        if (datosusuario.rows.length === 0) return res.status(401).json({ error: "Usuario no registrado" });
        console.log(datosusuario);
        // const validPassword = await bcrypt.compare(req.body.password, datosusuario.rows[0].password);
        if (req.body.password != datosusuario.rows[0].password) return res.status(401).json({ error: "Contraseña incorrecta" });
        res.status(200).json(datosusuario.rows[0]);
    } catch (e) {
        console.log(e);
        res.status(500).send('Hubo un error');
    }
};

export const seleccionPostulantebyID = async(req, res) => {
    try {
        const value1 = [req.params.id];
        const text = 'SELECT  LU.DIRECC_EMAIL,LU.NOMBRE,F.FECHA_INSCRIPCIÓN,SO.ESTADO,SO.PUNTAJE_OBTENIDO,CA.NOMBRE FROM  PERSONA LU,INSCRIPCION_CONVOC_POSTUL F,POSTULANTE JI , EVALUACION_POSTULANTE SO , EVALUACION CA WHERE LU.DOC_ID=JI.DOC_ID AND JI.DOC_ID=F.DOC_ID_POSTULANTE AND JI.DOC_ID=SO.DOC_ID_POSTULANTE AND SO.DOC_ID_POSTULANTE=CA.DOC_ID_POSTULANTE AND TIPO_EVALUACION=$1';
        const datospersonas = await pool.query(text, value1)
        res.status(200).json(datospersonas.rows);
    } catch (e) {
        console.log(e);
        res.status(500).send('Hubo un error');
    }
};

/*     const postulante2 = {link_linkedin: 'asdwd',
      lugar_residencia: 'asdwd',
      antecedentes_penales: 'asdwd',
      curriculum_vitae: 'asdwd',
      situacion_laboral_actual: 'asdwd',
      tipo_contrato_deseado: 'asdwd',
      movilidad: 'asdwd',
      doc_id_postulante: '15641561',
      doc_id_empleador: '',
      doc_id: '15641561',
      apellidos:'guiter', 
      nombre_pila:'caser', 
      foto:'asdwds', 
      fec_nac: '28/11/1999',
      sexo: 'M', 
      direcc_email: 'sdwdas',
      nombre_usuario: 'nombreprueba',
      password: 'sdwdas',
      rol: 'sdwdas',
      pais: 'sdwdas',
      ciudad: 'sdwdas'};
    console.log(postulante2); */