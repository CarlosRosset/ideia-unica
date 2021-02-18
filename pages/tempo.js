import Link from 'next/link'

function Tempo(props) {

    const dinamicDate = new Date();
    const dinamicDateString = dinamicDate.toGMTString();

    return (
        <div>
            <h1>Tempo</h1>
            <Menu />

            <div>{dinamicDateString} (Dinâmico)</div>
            <div>{props.staticDateString} (Estático)</div>

        </div>
    )
}

export function getStaticProps() {
    const staticDate = new Date();
    const staticDateString = staticDate.toGMTString();

    return {
        props: {
            staticDateString
        }
    }
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
                <Link href="/sobre">
                    <a>Acessar pág sobre</a>
                </Link>
            </div>
            <div>
                <Link href="/contar">
                    <a>Acessar pág Contar</a>
                </Link>
            </div>
        </div>
    )
}

export default Tempo;