import { Schema, model } from "mongoose";
import mongoosePaginate from 'mongoose-paginate-v2'
const taskSchema = new Schema({
    nombreconsulta: {
        type: String,
        required: true,
        trim: true
    },
    rucconsulta: {
        type: String,
        trim: true
    },
    correoconsulta: {
        type: String,
        trim: true
    },
    numeroconsulta: {
        type: Number,
        trim: true
    },
    mensajeconsulta: {
        type: String,
        trim: true
    },
    done: {
        type: Boolean,
        default: false
    },
}, {
    versionKey: false,
    timestamps: true
});

// Change the '_id' property name to 'id'
taskSchema.method("toJSON", function() {
    const { __v, _id, ...object } = this.toObject();
    object.id = _id;
    return object;
});

taskSchema.plugin(mongoosePaginate);
export default model('ConsultadeVisitante', taskSchema)