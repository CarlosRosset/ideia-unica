import Link from 'next/link'

function Home() {
    return (
        <div>
            <h1>Home</h1>
            <br></br>
            <Link href="/sobre">
                <a>Acessar pág Sobre</a>
            </Link>
            <br></br>
            <Link href="/contar">
                <a>Acessar pág Contar</a>
            </Link>
        </div>
    )
}

export default Home;