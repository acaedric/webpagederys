import { Router } from "express";
import * as taskCtrl from '../controllers/task.controllers2';

const router = Router();


router.get('/listadeconvocatorias', taskCtrl.obtenerConvocatorias);

export default router;