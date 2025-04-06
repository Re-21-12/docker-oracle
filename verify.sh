#!/bin/bash

echo "Esperando a que Oracle esté listo (esto puede tomar unos minutos)..."
sleep 60

echo "Verificando tablas..."
docker exec -i oracle-bancario bash -c "
sqlplus BANCARIO/Alfredo+123 <<EOF
set heading off
set feedback off
set pagesize 0
select 'Tabla '||table_name||' creada correctamente' 
from all_tables 
where owner = 'BANCARIO' 
and table_name in ('BITACORA','BITACORA_PAGO','CAJA_AHORRO','CLIENTE','MOVIMIENTO','PRESTAMO','TARJETA','TITULAR');
exit;
EOF
" || { echo "❌ Error al verificar tablas"; exit 1; }

echo "Verificando objetos adicionales..."
docker exec -i oracle-bancario bash -c "
sqlplus BANCARIO/Alfredo+123 <<EOF
set heading off
set feedback off
set pagesize 0
select 'Objeto '||object_name||' de tipo '||object_type||' creado correctamente' 
from all_objects 
where owner = 'BANCARIO' 
and object_type in ('SEQUENCE','PROCEDURE','TRIGGER')
and (object_name like 'BITACORA%' or object_name like 'ACTUALIZAR%');
exit;
EOF
" || { echo "❌ Error al verificar objetos"; exit 1; }

echo ""
echo "✅ Verificación completada."
echo "Puedes conectarte con:"
echo "  Usuario: BANCARIO"
echo "  Password: Alfredo+123"
echo "  SID: FREE"
echo "  Puerto: 1521"
