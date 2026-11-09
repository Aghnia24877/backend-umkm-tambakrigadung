
const express = require('express');
const cors = require('cors');
const db = require('./config/database');

const app = express();
const PORT = 3000;

app.use(cors());
app.use(express.json());

// Halaman utama API
app.get('/', (req, res) => {
    res.json({
        message: 'Backend Portal UMKM dan Potensi Desa Tambakrigadung berhasil berjalan!'
    });
});

// GET - Menampilkan semua kategori potensi desa
app.get('/api/kategori-potensi', async (req, res) => {
    try {
        const result = await db.query(
            'SELECT * FROM kategori_potensi ORDER BY id'
        );

        res.json(result.rows);
    } catch (error) {
        res.status(500).json({
            message: 'Gagal mengambil data kategori potensi',
            error: error.message
        });
    }
});

// GET - Menampilkan kategori potensi berdasarkan ID
app.get('/api/kategori-potensi/:id', async (req, res) => {
    try {
        const { id } = req.params;

        const result = await db.query(
            'SELECT * FROM kategori_potensi WHERE id = $1',
            [id]
        );

        if (result.rows.length === 0) {
            return res.status(404).json({
                message: 'Kategori potensi tidak ditemukan'
            });
        }

        res.json(result.rows[0]);
    } catch (error) {
        res.status(500).json({
            message: 'Gagal mengambil kategori potensi',
            error: error.message
        });
    }
});

// POST - Menambahkan kategori potensi desa
app.post('/api/kategori-potensi', async (req, res) => {
    try {
        const { nama_kategori, deskripsi } = req.body;

        const result = await db.query(
            `INSERT INTO kategori_potensi (nama_kategori, deskripsi)
             VALUES ($1, $2)
             RETURNING *`,
            [nama_kategori, deskripsi]
        );

        res.status(201).json({
            message: 'Kategori potensi berhasil ditambahkan',
            data: result.rows[0]
        });
    } catch (error) {
        res.status(500).json({
            message: 'Gagal menambahkan kategori potensi',
            error: error.message
        });
    }
});


 // PUT - Mengubah kategori potensi desa
app.put('/api/kategori-potensi/:id', async (req, res) => {
    try {
        const { id } = req.params;
        const { nama_kategori, deskripsi } = req.body;

        const result = await db.query(
            `UPDATE kategori_potensi
             SET nama_kategori = $1, deskripsi = $2
             WHERE id = $3
             RETURNING *`,
            [nama_kategori, deskripsi, id]
        );

        if (result.rows.length === 0) {
            return res.status(404).json({
                message: 'Kategori potensi tidak ditemukan'
            });
        }

        res.json({
            message: 'Kategori potensi berhasil diperbarui',
            data: result.rows[0]
        });
    } catch (error) {
        res.status(500).json({
            message: 'Gagal memperbarui kategori potensi',
            error: error.message
        });
    }
});

// DELETE - Menghapus kategori potensi desa
app.delete('/api/kategori-potensi/:id', async (req, res) => {
    try {
        const { id } = req.params;

        const result = await db.query(
            'DELETE FROM kategori_potensi WHERE id = $1 RETURNING *',
            [id]
        );

        if (result.rows.length === 0) {
            return res.status(404).json({
                message: 'Kategori potensi tidak ditemukan'
            });
        }

        res.json({
            message: 'Kategori potensi berhasil dihapus',
            data: result.rows[0]
        });
    } catch (error) {
        res.status(500).json({
            message: 'Gagal menghapus kategori potensi',
            error: error.message
        });
    }
});

// Menjalankan server
app.listen(PORT, () => {
    console.log(`Server berjalan di http://localhost:${PORT}`);
});
