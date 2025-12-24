import React, { useState } from 'react';
import './App.css';

function App() {
  const [username, setUsername] = useState('');
  const [password, setPassword] = useState('');

  const handleLogin = (e) => {
    e.preventDefault();
    console.log("Login attempted with:", username);
    // Future login logic here
  };

  return (
    <div className="app-container">
      <div className="bg-decoration"></div>

      <div className="content-wrapper">
        <div className="login-card">
          <div className="logos-container">
            <img src="/sapdlogo.png" alt="LSPD Logo" className="logo" />
            <img src="/dblogo.png" alt="Detective Bureau Logo" className="logo" />
          </div>

          <div className="header-text">
            <h1>Los Santos Police Department</h1>
            <h2>Detective Bureau</h2>
          </div>

          <form className="login-form" onSubmit={handleLogin}>
            <div className="input-group">
              <input
                type="text"
                placeholder="Nombre de Usuario"
                value={username}
                onChange={(e) => setUsername(e.target.value)}
              />
            </div>
            <div className="input-group">
              <input
                type="password"
                placeholder="Contraseña"
                value={password}
                onChange={(e) => setPassword(e.target.value)}
              />
            </div>

            <button type="submit" className="login-btn">
              Access Database
            </button>
          </form>

          <div className="footer-text">
            <p>Authorized Personnel Only • Secure Connection</p>
          </div>
        </div>
      </div>
    </div>
  );
}

export default App;
