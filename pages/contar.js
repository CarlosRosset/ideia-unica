import { useState } from "react";
import Link from 'next/link'

function Contar() {
    return (
        <div>
            <h1>Contar</h1>
            <Menu />
            <Contador />
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
                <Link href="/">
                    <a>Acessar pág Home</a>
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

function Contador() {
    const [contador, setContador] = useState(1);

    function adicionarContador() {
        setContador(contador + 1);
    }

    return (
        <div>
            <div>{contador}</div>
            <button onClick={adicionarContador} >Incrementar Contador</button>
        </div>
    )
}

export default Contar;