import { crearToken, validarToken, crearTokenProv } from "../config/config.js";
import md5 from "md5";
import { db, storage } from "../config/config.js";
import crypto from "crypto";

export const registrarCliente = async (req, res) => {
  try {
    const { nombre, usuario, pass, correo, cel, tipo } = req.body;
    let mensaje = "";
    // Agregar Info a la base de datos
    const [correo_ver] = await db.query(`call getCorreo ('${correo}');`);
    if (correo_ver[0][0].total <= 0) {
      //registro de cliente
      await db.query(
        `call insertClient ('${nombre}', '${usuario}', '${md5(
          pass
        )}', '${correo}','${cel}','${tipo}');`
      );
      mensaje = "Usuario registrado exitosamente.";
      return res.status(200).json({ success: true, message: mensaje });
    } else {
      mensaje = "Correo Existente";
      return res.status(400).json({ success: false, message: mensaje });
    }
  } catch (error) {
    const mensaje = "algo ocurrio mal";
    console.log(error);
    return res.status(400).json({ success: false, message: mensaje });
  }
};

export const registrarTransporte = async (req, res) => {
  try {
    const { tipo, ruta, piloto } = req.body;

    let mensaje = "";
    // Agregar Info a la base de datos
    const [piloto_ver] = await db.query(`call getPiloto ('${piloto}');`);
    if (piloto_ver[0][0].total <= 0) {
      //registro de cliente
      await db.query(`call insertClient ('${tipo}', '${ruta}', '${piloto}');`);
      mensaje = "Tranporte registrado exitosamente.";
      return res.status(200).json({ success: true, message: mensaje });
    } else {
      mensaje = "Correo Existente";
      return res.status(400).json({ success: false, message: mensaje });
    }
  } catch (error) {
    const mensaje = "algo ocurrio mal";
    console.log(error);
    return res.status(400).json({ success: false, message: mensaje });
  }
};

export const editarUsuario = async (req, res) => {
  try {
    const {
      idCliente,
      nombre,
      apellido = "",
      telefono = "",
      direccion = "",
      password = "",
    } = req.body;
    let mensaje = "";
    const [user] = await db.query(`call getIdUser ('${idCliente}');`);
    console.log(user[0][0]);
    if (user[0][0].idTipo == 1 || user[0][0].idTipo == 2) {
      await db.query(
        `call updateUser ('${idCliente}','${nombre}', '${apellido}', '${telefono}','${direccion}','${md5(
          password
        )}');`
      );
      mensaje = "Usuario actualizado exitosamente.";
      return res.status(200).json({ resultado: mensaje });
    } else {
      mensaje = "Acceso denegado";
      return res.status(400).json({ resultado: mensaje });
    }
  } catch (error) {
    const mensaje = "algo ocurrio mal";
    console.log(error);
    return res.status(500).json({ resultado: mensaje });
  }
};

export const InicioSesion = async (req, res) => {
  try {
    const { correo, pass, tipo } = req.body;
    let mensaje = "";
    const [result] = await db.query(
      `call getUsername ('${correo}','${md5(pass)}');`
    );
    if (result[0][0] != null) {
      const id = result[0][0].id_usuario;
      const correo = result[0][0].email;
      const nombre = result[0][0].nombre;
      const tipo = result[0][0].Tipo_Usuario;
      console.log(result[0][0]);
      mensaje = "Inicio de sesion exitoso.";
      return res.status(200).json({
        success: true,
        tipo: tipo,
        message: {
          Id: id,
          Nombre: nombre,
          Correo: correo,
        },
      });
    } else {
      mensaje = "Contraseña o correo incorrectos";
      return res.status(400).json({ success: false, message: mensaje });
    }
  } catch (error) {
    const mensaje = "algo ocurrio mal";
    console.log(error);
    return res.status(400).json({ success: false, message: mensaje });
  }
};

export const obtenerUsuario = async (req, res) => {
  try {
    let mensaje = "";
    const idCliente = req.params;

    const [user] = await db.query(`call getIdUser ('${idCliente.id}');`);

    if (user[0][0].idTipo == 1 || user[0][0].idTipo == 2) {
      const [result] = await db.query(`call getUserid ('${idCliente.id}');`);
      mensaje = "Cliente obtenido exitosamente.";
      return res.status(200).json({
        resultado: mensaje,
        data: result[0],
      });
    } else {
      mensaje = "tipo no encontrado";
      return res.status(400).json({ resultado: mensaje });
    }
  } catch (error) {
    const mensaje = "algo ocurrio mal";
    console.log(error);
    return res.status(500).json({ resultado: mensaje });
  }
};
