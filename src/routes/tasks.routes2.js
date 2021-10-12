import { Router } from "express";
import * as taskCtrl from '../controllers/task.controllers2'
import path from "path";

const router = Router();

var multer = require('multer');

var direccion = path.join(__dirname, '../../src/public/archivos');

var storage = multer.diskStorage({
    destination: function (req, file, cb) {
        cb(null, direccion)
    },
    filename: function (req, file, cb) {
        cb(null, Date.now() + '-' + file.originalname)
    }
})

const upload = multer({ 
    storage, 
    dest: direccion, 
    limits: { filesize: 50000000 }, 
    fileFilter: (req, file, cb) => { 
        const filetypes = /jpeg|png|gif|jpg|JPG|PNG|pdf|gif|ppt|pptx|doc|docx|dot|zip|htm|html|xls|xlsx|txt|odf|odg|odt|odm|odp|ods|ai|ait|psd|psb|eps|raw|bmp|dicom|pbm|wbmp/;
        const mimetype = filetypes.test(file.mimetype);
        const extname = filetypes.test(path.extname(file.originalname));
        if (mimetype && extname) {
            return cb(null, true);
        }
        cb("Error: Archivo debe ser un archivo válido(imagen, pdf, word, ppt, zip, ai, psd, psb)");
    } 
}).single('archivoconsulta');



router.get('/consultas', taskCtrl.findConsultas);
router.post('/consultas', upload, taskCtrl.consulta);
// router.post('/consultas', taskCtrl.consulta);




export default router;