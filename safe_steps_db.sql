-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1:3307
-- Tiempo de generación: 25-11-2026 a las 14:14:47
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
  `id_alerta` char(36) NOT NULL,
  `id_deteccion` char(36) NOT NULL,
  `id_operador` char(36) DEFAULT NULL,
  `frecuencia_audible_hz` int(11) NOT NULL,
  `estado` enum('EMITIDA','EN_REVISION','DESCARTADA','RESUELTA') NOT NULL DEFAULT 'EMITIDA',
  `created_at` timestamp(3) NOT NULL DEFAULT current_timestamp(3),
  `atendida_at` timestamp(3) NULL DEFAULT NULL,
  `observaciones` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `alertas_emitidas`
--

INSERT INTO `alertas_emitidas` (`id_alerta`, `id_deteccion`, `id_operador`, `frecuencia_audible_hz`, `estado`, `created_at`, `atendida_at`, `observaciones`) VALUES
('alt-000001-warn-001', 'det-000001-yolo-001', NULL, 880, 'EMITIDA', '2026-09-02 22:44:07.377', NULL, NULL),
('alt-000002-warn-002', 'det-000002-yolo-002', NULL, 440, 'RESUELTA', '2026-09-02 22:44:07.377', NULL, NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `camaras`
--

CREATE TABLE `camaras` (
  `id_camara` int(11) NOT NULL,
  `id_zona` int(11) NOT NULL,
  `codigo_camara` varchar(50) NOT NULL,
  `ip_direccion` varchar(45) NOT NULL,
  `latitud` decimal(10,8) NOT NULL,
  `longitud` decimal(11,8) NOT NULL,
  `estado` enum('ACTIVA','INACTIVA','MANTENIMIENTO') NOT NULL DEFAULT 'ACTIVA'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `camaras`
--

INSERT INTO `camaras` (`id_camara`, `id_zona`, `codigo_camara`, `ip_direccion`, `latitud`, `longitud`, `estado`) VALUES
(1, 1, 'CAM-7-45-NORTH', '192.168.10.50', 4.63510000, -74.06520000, 'ACTIVA'),
(2, 2, 'CAM-SUBA-100-WEST', '192.168.10.51', 4.68820000, -74.08540000, 'ACTIVA');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `comentarios_asociados`
--

CREATE TABLE `comentarios_asociados` (
  `id_comentario` char(36) NOT NULL,
  `entidad_tipo` varchar(50) NOT NULL,
  `entidad_id` char(36) NOT NULL,
  `id_usuario` char(36) NOT NULL,
  `comentario` text NOT NULL,
  `created_at` timestamp(3) NOT NULL DEFAULT current_timestamp(3)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `detecciones`
--

CREATE TABLE `detecciones` (
  `id_deteccion` char(36) NOT NULL,
  `id_camara` int(11) NOT NULL,
  `id_tipo` int(11) NOT NULL,
  `nivel_confianza` decimal(5,2) NOT NULL,
  `bounding_box` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`bounding_box`)),
  `url_frame` varchar(255) DEFAULT NULL,
  `created_at` timestamp(3) NOT NULL DEFAULT current_timestamp(3)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `detecciones`
--

INSERT INTO `detecciones` (`id_deteccion`, `id_camara`, `id_tipo`, `nivel_confianza`, `bounding_box`, `url_frame`, `created_at`) VALUES
('det-000001-yolo-001', 1, 2, 96.80, '{\"x\": 120, \"y\": 340, \"w\": 450, \"h\": 200}', NULL, '2026-09-02 22:44:07.355'),
('det-000002-yolo-002', 2, 1, 91.15, '{\"x\": 80, \"y\": 210, \"w\": 200, \"h\": 150}', NULL, '2026-09-02 22:44:07.355');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `operadores_especializados`
--

CREATE TABLE `operadores_especializados` (
  `id_usuario` char(36) NOT NULL,
  `nivel_certificacion` varchar(50) NOT NULL,
  `protocolo_asignado` varchar(100) DEFAULT NULL,
  `horas_turno_activo` int(11) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `roles`
--

CREATE TABLE `roles` (
  `id_rol` int(11) NOT NULL,
  `nombre` varchar(50) NOT NULL,
  `descripcion` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `roles`
--

INSERT INTO `roles` (`id_rol`, `nombre`, `descripcion`) VALUES
(1, 'Administrador', 'Gestion de infraestructura y camaras'),
(2, 'Operador Movilidad', 'Monitoreo de eventos y alertas en tiempo real');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tipos_deteccion`
--

CREATE TABLE `tipos_deteccion` (
  `id_tipo` int(11) NOT NULL,
  `clase_yolo` varchar(50) NOT NULL,
  `nivel_riesgo` enum('BAJO','MEDIO','ALTO','CRITICO') NOT NULL,
  `descripcion` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `tipos_deteccion`
--

INSERT INTO `tipos_deteccion` (`id_tipo`, `clase_yolo`, `nivel_riesgo`, `descripcion`) VALUES
(1, 'car', 'MEDIO', 'Vehiculo de pasajeros en aproximacion'),
(2, 'bus', 'ALTO', 'Vehiculo de transporte publico o carga'),
(3, 'person', 'BAJO', 'Peaton transitando por la cebra');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuarios`
--

CREATE TABLE `usuarios` (
  `id_usuario` char(36) NOT NULL,
  `id_rol` int(11) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `apellido` varchar(100) NOT NULL,
  `email` varchar(150) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `estado` enum('ACTIVO','INACTIVO') NOT NULL DEFAULT 'ACTIVO',
  `created_at` timestamp(3) NOT NULL DEFAULT current_timestamp(3),
  `updated_at` timestamp(3) NOT NULL DEFAULT current_timestamp(3) ON UPDATE current_timestamp(3),
  `deleted_at` timestamp(3) NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `usuarios`
--

INSERT INTO `usuarios` (`id_usuario`, `id_rol`, `nombre`, `apellido`, `email`, `password_hash`, `estado`, `created_at`, `updated_at`, `deleted_at`) VALUES
('usr-000001-admin-001', 1, 'Matias', 'Iglesias', 'admin@safesteps.gov.co', 'hash_pass_123', 'ACTIVO', '2026-09-02 22:44:07.295', '2026-09-02 22:44:07.295', NULL),
('usr-000002-oper-002', 2, 'Kevin', 'Sanabria', 'kevin@safesteps.gov.co', 'hash_pass_456', 'ACTIVO', '2026-09-02 22:44:07.295', '2026-09-02 22:44:07.295', NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `zonas`
--

CREATE TABLE `zonas` (
  `id_zona` int(11) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `sector_ciudad` varchar(100) NOT NULL,
  `descripcion` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `zonas`
--

INSERT INTO `zonas` (`id_zona`, `nombre`, `sector_ciudad`, `descripcion`) VALUES
(1, 'Semaforo Carrera 7 con Calle 45', 'Chapinero', 'Cruce peatonal de alta densidad'),
(2, 'Interseccion Av. Suba con Calle 100', 'Suba', 'Zona escolar con prioridad peatonal'),
(4, 'Alamos', 'Bogotá', '');

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `alertas_emitidas`
--
ALTER TABLE `alertas_emitidas`
  ADD PRIMARY KEY (`id_alerta`),
  ADD KEY `fk_alertas_deteccion` (`id_deteccion`),
  ADD KEY `fk_alertas_operador` (`id_operador`);

--
-- Indices de la tabla `camaras`
--
ALTER TABLE `camaras`
  ADD PRIMARY KEY (`id_camara`),
  ADD UNIQUE KEY `codigo_camara` (`codigo_camara`),
  ADD KEY `fk_camaras_zonas` (`id_zona`);

--
-- Indices de la tabla `comentarios_asociados`
--
ALTER TABLE `comentarios_asociados`
  ADD PRIMARY KEY (`id_comentario`),
  ADD KEY `idx_polimorfico` (`entidad_tipo`,`entidad_id`),
  ADD KEY `fk_comentario_usuario` (`id_usuario`);

--
-- Indices de la tabla `detecciones`
--
ALTER TABLE `detecciones`
  ADD PRIMARY KEY (`id_deteccion`),
  ADD KEY `fk_detecciones_camara` (`id_camara`),
  ADD KEY `fk_detecciones_tipo` (`id_tipo`);

--
-- Indices de la tabla `operadores_especializados`
--
ALTER TABLE `operadores_especializados`
  ADD PRIMARY KEY (`id_usuario`);

--
-- Indices de la tabla `roles`
--
ALTER TABLE `roles`
  ADD PRIMARY KEY (`id_rol`),
  ADD UNIQUE KEY `nombre` (`nombre`);

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
  ADD UNIQUE KEY `email` (`email`),
  ADD KEY `fk_usuarios_roles` (`id_rol`);

--
-- Indices de la tabla `zonas`
--
ALTER TABLE `zonas`
  ADD PRIMARY KEY (`id_zona`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `camaras`
--
ALTER TABLE `camaras`
  MODIFY `id_camara` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `roles`
--
ALTER TABLE `roles`
  MODIFY `id_rol` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `tipos_deteccion`
--
ALTER TABLE `tipos_deteccion`
  MODIFY `id_tipo` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `zonas`
--
ALTER TABLE `zonas`
  MODIFY `id_zona` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `alertas_emitidas`
--
ALTER TABLE `alertas_emitidas`
  ADD CONSTRAINT `fk_alertas_deteccion` FOREIGN KEY (`id_deteccion`) REFERENCES `detecciones` (`id_deteccion`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_alertas_operador` FOREIGN KEY (`id_operador`) REFERENCES `usuarios` (`id_usuario`) ON DELETE SET NULL;

--
-- Filtros para la tabla `camaras`
--
ALTER TABLE `camaras`
  ADD CONSTRAINT `fk_camaras_zonas` FOREIGN KEY (`id_zona`) REFERENCES `zonas` (`id_zona`);

--
-- Filtros para la tabla `comentarios_asociados`
--
ALTER TABLE `comentarios_asociados`
  ADD CONSTRAINT `fk_comentario_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id_usuario`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `detecciones`
--
ALTER TABLE `detecciones`
  ADD CONSTRAINT `fk_detecciones_camara` FOREIGN KEY (`id_camara`) REFERENCES `camaras` (`id_camara`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_detecciones_tipo` FOREIGN KEY (`id_tipo`) REFERENCES `tipos_deteccion` (`id_tipo`);

--
-- Filtros para la tabla `operadores_especializados`
--
ALTER TABLE `operadores_especializados`
  ADD CONSTRAINT `fk_operador_herencia_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id_usuario`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `usuarios`
--
ALTER TABLE `usuarios`
  ADD CONSTRAINT `fk_usuarios_roles` FOREIGN KEY (`id_rol`) REFERENCES `roles` (`id_rol`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
