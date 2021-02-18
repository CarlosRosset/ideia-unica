import Link from 'next/link'

function Sobre() {
    return (
        <div>
            <h1>Sobre</h1>
            <Menu />
        </div>
    )
}

function Menu() {
    return (
        <div>
            <div>
                <Link href="/">
                    <a>Acessar pág Home</a>
                </Link>
            </div>
            <div>
                <Link href="/contar">
                    <a>Acessar pág Contar</a>
                </Link>
            </div>
            <div>
                <Link href="/tempo">
                    <a>Acessar pág Tempo</a>
                </Link>
            </div>
        </div>
    )
}

export default Sobre;