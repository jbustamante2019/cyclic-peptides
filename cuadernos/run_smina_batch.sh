

# Definición de rutas
RECEPTOR="/Users/blillo/juancarlos/docking/PDBQT_recep/ACVR1_FOP_F7742.pdbqt"
LIGAND_DIR="/Users/blillo/juancarlos/docking/ligandos_obabel"
OUT_DIR="/Users/blillo/juancarlos/docking/resultados_smina"
LOG_DIR="$OUT_DIR/logs"
RESUMEN="$OUT_DIR/resumen_scores.csv"

# Crear carpetas de salida si no existen
mkdir -p "$OUT_DIR"
mkdir -p "$LOG_DIR"

# Parámetros de docking
CENTER_X=3.849
CENTER_Y=69.620
CENTER_Z=55.382
SIZE_X=25
SIZE_Y=25
SIZE_Z=25
EXHAUSTIVENESS=4
CPU=10

# Encabezado del archivo resumen
echo "Ligando,Score" > "$RESUMEN"

# Loop por cada ligando
for LIGAND in "$LIGAND_DIR"/*.pdbqt; do
    BASENAME=$(basename "$LIGAND" .pdbqt)
    OUTPUT="$OUT_DIR/${BASENAME}_out.pdbqt"
    LOGFILE="$LOG_DIR/${BASENAME}.log"

    echo "Procesando $BASENAME..."

    # Ejecutar docking
    smina --receptor "$RECEPTOR" \
          --ligand "$LIGAND" \
          --center_x $CENTER_X \
          --center_y $CENTER_Y \
          --center_z $CENTER_Z \
          --size_x $SIZE_X \
          --size_y $SIZE_Y \
          --size_z $SIZE_Z \
          --exhaustiveness $EXHAUSTIVENESS \
          --cpu $CPU \
          --scoring vina \
          --out "$OUTPUT" \
          --log "$LOGFILE"

    # Extraer el mejor score (primera línea con "REMARK VINA RESULT")
    SCORE=$(grep "^REMARK VINA RESULT" "$LOGFILE" | head -n 1 | awk '{print $4}')

    # Guardar en resumen
    echo "$BASENAME,$SCORE" >> "$RESUMEN"
done

echo "✅ Docking finalizado. Resumen guardado en: $RESUMEN"
