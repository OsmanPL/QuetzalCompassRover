import React, { createContext, useCallback, useContext, useMemo, useState } from "react";
import { USER_API_BASE } from "../config/api.js";

const AuthContext = createContext({
  token: null,
  user: null,
  loading: false,
  error: null,
  signIn: async () => ({ success: false }),
  signOut: () => {},
  signUp: async () => ({ success: false }),
});

export function AuthProvider({ children }) {
  const [token, setToken] = useState(null);
  const [user, setUser] = useState(null);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState(null);

  const signIn = useCallback(async ({ correo, pass }) => {
    setLoading(true);
    setError(null);
    try {
      const response = await fetch(`${USER_API_BASE}/Login`, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ correo, pass }),
      });
      const json = await response.json().catch(() => ({}));
      if (!response.ok || !json?.success || !json?.token) {
        const message = json?.message || "Credenciales invalidas";
        setToken(null);
        setUser(null);
        setError(message);
        return { success: false, message };
      }
      setToken(json.token);
      setUser(json.user || null);
      return { success: true, user: json.user || null };
    } catch (err) {
      const message = err?.message || "No fue posible iniciar sesion";
      setToken(null);
      setUser(null);
      setError(message);
      return { success: false, message };
    } finally {
      setLoading(false);
    }
  }, []);

  const signOut = useCallback(() => {
    setToken(null);
    setUser(null);
    setError(null);
  }, []);

  const signUp = useCallback(async ({ nombre, usuario, pass, correo, cel, tipo = 2 }) => {
    try {
      const response = await fetch(`${USER_API_BASE}/Cliente/Registrar`, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ nombre, usuario, pass, correo, cel, tipo }),
      });
      const json = await response.json().catch(() => ({}));
      if (!response.ok || !json?.success) {
        const message = json?.message || "No fue posible registrar la cuenta";
        return { success: false, message };
      }
      return { success: true, message: json?.message || "Usuario registrado exitosamente." };
    } catch (err) {
      const message = err?.message || "No fue posible registrar la cuenta";
      return { success: false, message };
    }
  }, []);

  const value = useMemo(
    () => ({ token, user, loading, error, signIn, signOut, signUp }),
    [token, user, loading, error, signIn, signOut, signUp],
  );

  return <AuthContext.Provider value={value}>{children}</AuthContext.Provider>;
}

export function useAuth() {
  return useContext(AuthContext);
}
