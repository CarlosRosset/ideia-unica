import Link from 'next/link'

function Home() {
    return (
        <div>
            <h1>Home</h1>
            <Menu />
        </div>
    )
}

function Menu() {
    return (
        <div>
            <div>
                <Link href="/sobre">
                    <a>Acessar pág Sobre</a>
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

export default Home;