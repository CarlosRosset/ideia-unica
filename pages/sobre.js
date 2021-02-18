import Link from 'next/link'

function Sobre() {
    return (
        <div>
            <h1>Sobre</h1>
            <br></br>
            <Link href="/">
                <a>Acessar pág Home</a>
            </Link>
            <br></br>
            <Link href="/contar">
                <a>Acessar pág Contar</a>
            </Link>

        </div>
    )
}

export default Sobre;