-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1:3307
-- Tiempo de generación: 02-09-2026 a las 16:29:18
-- Versión del servidor: 10.4.32-MariaDB
-- Versión de PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `safe_steps_db`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `alertas_emitidas`
--

CREATE TABLE `alertas_emitidas` (
  `id_alerta` int(11) NOT NULL,
  `id_deteccion` int(11) NOT NULL,
  `id_usuario_atencion` int(11) DEFAULT NULL COMMENT 'El operador que revisó la alerta',
  `estado` enum('Pendiente','En_Revision','Resuelta','Falsa_Alarma') DEFAULT 'Pendiente',
  `fecha_emision` timestamp NOT NULL DEFAULT current_timestamp(),
  `fecha_atencion` timestamp NULL DEFAULT NULL,
  `observaciones` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `camaras`
--

CREATE TABLE `camaras` (
  `id_camara` int(11) NOT NULL,
  `id_zona` int(11) DEFAULT NULL,
  `nombre_camara` varchar(100) NOT NULL,
  `ip_direccion` varchar(45) DEFAULT NULL,
  `latitud` decimal(10,8) DEFAULT NULL COMMENT 'Coordenada espacial',
  `longitud` decimal(11,8) DEFAULT NULL COMMENT 'Coordenada espacial',
  `estado` enum('Activa','Inactiva','Mantenimiento') DEFAULT 'Activa'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `detecciones`
--

CREATE TABLE `detecciones` (
  `id_deteccion` int(11) NOT NULL,
  `id_camara` int(11) NOT NULL,
  `id_tipo` int(11) NOT NULL,
  `fecha_hora` timestamp NOT NULL DEFAULT current_timestamp(),
  `nivel_confianza` decimal(5,2) DEFAULT NULL COMMENT 'Porcentaje de certeza de la IA (ej. 95.50)',
  `url_evidencia` varchar(255) DEFAULT NULL COMMENT 'Ruta donde se guarda la foto/video de la detección'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `logs_auditoria`
--

CREATE TABLE `logs_auditoria` (
  `id_log` int(11) NOT NULL,
  `id_usuario` int(11) DEFAULT NULL,
  `accion` varchar(255) NOT NULL,
  `fecha_hora` timestamp NOT NULL DEFAULT current_timestamp(),
  `detalles` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `reportes_movilidad`
--

CREATE TABLE `reportes_movilidad` (
  `id_reporte` int(11) NOT NULL,
  `id_zona` int(11) NOT NULL,
  `fecha_inicio` datetime NOT NULL,
  `fecha_fin` datetime NOT NULL,
  `conteo_personas` int(11) DEFAULT 0,
  `conteo_vehiculos` int(11) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `roles`
--

CREATE TABLE `roles` (
  `id_rol` int(11) NOT NULL,
  `nombre_rol` varchar(50) NOT NULL,
  `descripcion` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tipos_deteccion`
--

CREATE TABLE `tipos_deteccion` (
  `id_tipo` int(11) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `nivel_severidad` enum('Bajo','Medio','Alto','Critico') NOT NULL,
  `descripcion` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuarios`
--

CREATE TABLE `usuarios` (
  `id_usuario` int(11) NOT NULL,
  `id_rol` int(11) DEFAULT NULL,
  `nombre_completo` varchar(150) NOT NULL,
  `correo` varchar(150) NOT NULL,
  `contrasena` varchar(255) NOT NULL,
  `estado` enum('Activo','Inactivo') DEFAULT 'Activo'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `zonas`
--

CREATE TABLE `zonas` (
  `id_zona` int(11) NOT NULL,
  `nombre_zona` varchar(100) NOT NULL,
  `descripcion` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `alertas_emitidas`
--
ALTER TABLE `alertas_emitidas`
  ADD PRIMARY KEY (`id_alerta`),
  ADD KEY `id_deteccion` (`id_deteccion`),
  ADD KEY `id_usuario_atencion` (`id_usuario_atencion`),
  ADD KEY `idx_estado` (`estado`);

--
-- Indices de la tabla `camaras`
--
ALTER TABLE `camaras`
  ADD PRIMARY KEY (`id_camara`),
  ADD KEY `id_zona` (`id_zona`);

--
-- Indices de la tabla `detecciones`
--
ALTER TABLE `detecciones`
  ADD PRIMARY KEY (`id_deteccion`),
  ADD KEY `id_camara` (`id_camara`),
  ADD KEY `id_tipo` (`id_tipo`),
  ADD KEY `idx_fecha` (`fecha_hora`);

--
-- Indices de la tabla `logs_auditoria`
--
ALTER TABLE `logs_auditoria`
  ADD PRIMARY KEY (`id_log`),
  ADD KEY `id_usuario` (`id_usuario`);

--
-- Indices de la tabla `reportes_movilidad`
--
ALTER TABLE `reportes_movilidad`
  ADD PRIMARY KEY (`id_reporte`),
  ADD KEY `id_zona` (`id_zona`),
  ADD KEY `idx_fechas` (`fecha_inicio`,`fecha_fin`);

--
-- Indices de la tabla `roles`
--
ALTER TABLE `roles`
  ADD PRIMARY KEY (`id_rol`);

--
-- Indices de la tabla `tipos_deteccion`
--
ALTER TABLE `tipos_deteccion`
  ADD PRIMARY KEY (`id_tipo`);

--
-- Indices de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  ADD PRIMARY KEY (`id_usuario`),
  ADD UNIQUE KEY `correo` (`correo`),
  ADD KEY `id_rol` (`id_rol`);

--
-- Indices de la tabla `zonas`
--
ALTER TABLE `zonas`
  ADD PRIMARY KEY (`id_zona`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `alertas_emitidas`
--
ALTER TABLE `alertas_emitidas`
  MODIFY `id_alerta` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `camaras`
--
ALTER TABLE `camaras`
  MODIFY `id_camara` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `detecciones`
--
ALTER TABLE `detecciones`
  MODIFY `id_deteccion` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `logs_auditoria`
--
ALTER TABLE `logs_auditoria`
  MODIFY `id_log` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `reportes_movilidad`
--
ALTER TABLE `reportes_movilidad`
  MODIFY `id_reporte` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `roles`
--
ALTER TABLE `roles`
  MODIFY `id_rol` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `tipos_deteccion`
--
ALTER TABLE `tipos_deteccion`
  MODIFY `id_tipo` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  MODIFY `id_usuario` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `zonas`
--
ALTER TABLE `zonas`
  MODIFY `id_zona` int(11) NOT NULL AUTO_INCREMENT;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `alertas_emitidas`
--
ALTER TABLE `alertas_emitidas`
  ADD CONSTRAINT `alertas_emitidas_ibfk_1` FOREIGN KEY (`id_deteccion`) REFERENCES `detecciones` (`id_deteccion`) ON DELETE CASCADE,
  ADD CONSTRAINT `alertas_emitidas_ibfk_2` FOREIGN KEY (`id_usuario_atencion`) REFERENCES `usuarios` (`id_usuario`) ON DELETE SET NULL;

--
-- Filtros para la tabla `camaras`
--
ALTER TABLE `camaras`
  ADD CONSTRAINT `camaras_ibfk_1` FOREIGN KEY (`id_zona`) REFERENCES `zonas` (`id_zona`) ON DELETE SET NULL;

--
-- Filtros para la tabla `detecciones`
--
ALTER TABLE `detecciones`
  ADD CONSTRAINT `detecciones_ibfk_1` FOREIGN KEY (`id_camara`) REFERENCES `camaras` (`id_camara`) ON DELETE CASCADE,
  ADD CONSTRAINT `detecciones_ibfk_2` FOREIGN KEY (`id_tipo`) REFERENCES `tipos_deteccion` (`id_tipo`);

--
-- Filtros para la tabla `logs_auditoria`
--
ALTER TABLE `logs_auditoria`
  ADD CONSTRAINT `logs_auditoria_ibfk_1` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id_usuario`) ON DELETE SET NULL;

--
-- Filtros para la tabla `reportes_movilidad`
--
ALTER TABLE `reportes_movilidad`
  ADD CONSTRAINT `reportes_movilidad_ibfk_1` FOREIGN KEY (`id_zona`) REFERENCES `zonas` (`id_zona`) ON DELETE CASCADE;

--
-- Filtros para la tabla `usuarios`
--
ALTER TABLE `usuarios`
  ADD CONSTRAINT `usuarios_ibfk_1` FOREIGN KEY (`id_rol`) REFERENCES `roles` (`id_rol`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
